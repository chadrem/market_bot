module MarketBot
  module Play
    class App
      attr_reader :app_id
      attr_reader *ATTRIBUTES
      attr_reader :hydra
      attr_reader :lang
      attr_reader :callback
      attr_reader :error
      attr_reader :result

      def self.parse(html, options={})
        result = {}

        doc = Nokogiri::HTML(html)
        meta_info = doc.css('.meta-info')
        meta_info.each do |info|
          field_name = info.css('.title').text.strip

          case field_name
          when 'Updated'
            result[:updated] = info.at_css('.content').text.strip
          when 'Installs'
            result[:installs] = info.at_css('.content').text.strip
          when 'Size'
            result[:size] = info.at_css('.content').text.strip
          when 'Current Version'
            result[:current_version] = info.at_css('.content').text.strip
          when 'Requires Android'
            result[:requires_android] = info.at_css('.content').text.strip
          when 'Contact Developer', 'Developer'
            info.css('.dev-link').each do |node|
              node_href = node[:href]
              if node_href =~ /^mailto:/
                result[:email] = node_href.gsub(/^mailto:/,'')
              else
                if q_param = URI(node_href).query.split('&').select{ |p| p =~ /q=/ }.first
                  actual_url = q_param.gsub('q=', '')
                end

                result[:website_url] = actual_url
              end
            end

          end
        end

        result[:content_rating] = doc.at_css("div.content[itemprop='contentRating']").text

        result[:price] = doc.at_css('meta[itemprop="price"]')[:content]

        category_div = doc.at_css('.category')
        result[:category] = category_div.text.strip rescue ''
        cat_link = category_div["href"]
        path, cat_name = File.split(cat_link)
        result[:category_url] = cat_name

        result[:description] = doc.at_css('div[itemprop="description"]').inner_html.strip
        result[:title] = doc.at_css('div.id-app-title').text

        score = doc.at_css('.score-container')
        unless score.nil?
          node  = score.at_css('.score')
          result[:rating] = node.text.strip
          node = score.at_css('meta[itemprop="ratingCount"]')
          result[:votes] = node[:content].strip
        end

        node = doc.at_css('div[itemprop="author"]')
        result[:developer] = node.at_css('.primary').text.strip

        result[:more_from_developer] = []
        result[:similar] = []

        node = doc.css('.recommendation')
        node.css('.rec-cluster').each do |recommended|
          assoc_app_type = recommended.at_css('.heading').text.strip.eql?('Similar' ) ? :similar : :more_from_developer
          recommended.css('.card').each do |card|
            assoc_app = {}
            assoc_app[:app_id] = card['data-docid'].strip

            result[assoc_app_type] << assoc_app
          end
        end

        node = doc.at_css('.cover-image')
        unless node.nil?
          url = MarketBot::Util.fix_content_url(node[:src])
          result[:banner_icon_url] = url
          result[:banner_image_url] = url
        end

        result[:screenshot_urls] = []
        doc.css('.screenshot').each do |node|
          result[:screenshot_urls] << MarketBot::Util.fix_content_url(node[:src])
        end

        result[:full_screenshot_urls] = []
        doc.css('.full-screenshot').each do |node|
          result[:full_screenshot_urls] << MarketBot::Util.fix_content_url(node[:src])
        end

        node = doc.at_css('.whatsnew')
        result[:whats_new] = node.inner_html.strip unless node.nil?

        result[:reviews] = []
        unless options[:skip_reviews] # Review parsing is CPU intensive.
          doc.css('.single-review').each do |node|
            review = {}
            review[:author_name] = node.at_css('.author-name').text.strip if node.at_css('.author-name')
            raw_tag = node.at_css('.current-rating').to_s
            if raw_tag.match(/100%;/i)
              review[:review_score] = 5
            elsif raw_tag.match(/80%;/i)
              review[:review_score] = 4
            elsif raw_tag.match(/60%;/i)
              review[:review_score] = 3
            elsif raw_tag.match(/40%;/i)
              review[:review_score] = 2
            elsif raw_tag.match(/20%;/i)
              review[:review_score] = 1
            end
            if node.at_css('.review-title')
              review[:review_title] = node.at_css('.review-title').text.strip
            end
            if node.at_css('.review-body')
              review[:review_text] = node.at_css('.review-body').text
                .sub!(review[:review_title],'')
                .sub!(node.at_css('.review-link').text, '')
                .strip
            end
            if review
              result[:reviews] << review
            end
          end
        end

        result[:rating_distribution] = { 5 => nil, 4 => nil, 3 => nil, 2 => nil, 1 => nil }

        histogram = doc.css('div.rating-histogram')
        cur_index = 5
        %w(five four three two one).each do |slot|
          node = histogram.at_css(".#{slot.to_s}")
          result[:rating_distribution][cur_index] = node.css('.bar-number').text.gsub(/,/,'').to_i
          cur_index -= 1

        end

        result[:html] = html

        result
      end

      def initialize(app_id, options={})
        @app_id = app_id
        @hydra = options[:hydra] || MarketBot.hydra
        @lang = options[:lang] || 'en'
        @callback = nil
        @error = nil
        @request_opts = options[:request_opts] || {}
        @request_opts[:timeout] ||= MarketBot.timeout
        @request_opts[:connecttimeout] ||= MarketBot.connecttimeout
      end

      def market_url
        "https://play.google.com/store/apps/details?id=#{@app_id}&hl=#{lang}"
      end

      def update
        req = Typhoeus::Request.new(market_url, @request_opts)
        req.run
        result = handle_response(req.response)
        update_callback(result)

        self
      end

      def enqueue_update(&block)
        @callback = block
        @error = nil

        request = Typhoeus::Request.new(market_url, @request_opts)

        request.on_complete do |response|
          result = nil

          begin
            result = handle_response(response)
          rescue Exception => e
            @error = e
          end

          update_callback(result)
        end

        hydra.queue(request)

        self
      end

      private

      def handle_response(response)
        if response.success?
          App.parse(response.body)
        else
          codes = "code=#{response.code}, return_code=#{response.return_code}"
          case response.code
          when 404
            raise MarketBot::NotFoundError.new("Unable to find app in store: #{codes}")
          when 403
            raise MarketBot::UnavailableError.new("Unavailable app (country restriction?): #{codes}")
          else
            raise MarketBot::ResponseError.new("Unhandled response: #{codes}")
          end
        end
      end

      def update_callback(result)
        unless @error
          @result = result

          ATTRIBUTES.each do |a|
            attr_name = "@#{a}"
            attr_value = result[a]
            instance_variable_set(attr_name, attr_value)
          end
        end

        @callback.call(self) if @callback
      end
    end
  end
end
