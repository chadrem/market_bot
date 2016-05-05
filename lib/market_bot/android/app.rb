module MarketBot
  module Android

    class App
      MARKET_ATTRIBUTES = [:title, :rating, :updated, :current_version, :requires_android,
                          :category, :installs, :size, :price, :content_rating, :description,
                          :votes, :developer, :more_from_developer, :users_also_installed,
                          :related, :banner_icon_url, :banner_image_url, :website_url, :email,
                          :youtube_video_ids, :screenshot_urls, :whats_new, :permissions,
                          :rating_distribution, :html, :category_url, :full_screenshot_urls,
                          :reviews]

      attr_reader :app_id
      attr_reader *MARKET_ATTRIBUTES
      attr_reader :hydra
      attr_reader :lang
      attr_reader :callback
      attr_reader :error

      def self.parse(html)
        result = {}

        doc = Nokogiri::HTML(html)
        meta_info = doc.css('.meta-info')
        meta_info.each do |info|
          field_name = info.css('.title').text.strip

          case field_name
            when 'Updated'
              result[:updated] = info.css('.content').text.strip
            when 'Installs'
              result[:installs] = info.css('.content').text.strip
            when 'Size'
              result[:size] = info.css('.content').text.strip
            when 'Current Version'
              result[:current_version] = info.css('.content').text.strip
            when 'Requires Android'
              result[:requires_android] = info.css('.content').text.strip
            when 'Content Rating'
              result[:content_rating] = info.css('.content').text.strip
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

        node = doc.xpath("//meta[@itemprop='price']").first
        result[:price] = node[:content].strip rescue 'Free'

        category_div = doc.css('.category').first
        result[:category] = category_div.text.strip rescue ''
        cat_link = category_div["href"]
        path, cat_name = File.split(cat_link)
        result[:category_url] = cat_name

        result[:description] = doc.xpath("//div[@itemprop='description']").first.inner_html.strip
        result[:title] = doc.xpath("//div[@itemprop='name']").first.text.strip

        score = doc.css('.score-container').first
        unless score.nil?
          node  = score.css('.score').first
          result[:rating] = node.text.strip
          node = score.xpath("//meta[@itemprop='ratingCount']").first
          result[:votes] = node[:content].strip
        end

        node = doc.xpath("//div[@itemprop='author']")
        result[:developer] = node.css('.primary').first.text.strip

        result[:more_from_developer] = []
        result[:users_also_installed] = []
        result[:related] = []

        node = doc.css('.recommendation')
        node.css('.rec-cluster').each do |recommended|
          assoc_app_type = recommended.css('.heading').first.text.strip.eql?('Similar' ) ? :related : :more_from_developer
          recommended.css('.card').each do |card|
            assoc_app = {}
            assoc_app[:app_id] = card['data-docid'].strip

            result[assoc_app_type] << assoc_app
          end
        end
        # Users also installed is no longer on the page, adding this for backwards compatibility, well, sort of....
        result[:users_also_installed] = result[:related]

        node = doc.css('.cover-image').first
        unless node.nil?
          result[:banner_icon_url] = node[:src]
          result[:banner_image_url] = node[:src]
        end

        result[:youtube_video_ids] = []
        doc.css('.play-action-container').each do |node|
          url = node['data-video-url']
          unless url.nil?
            result[:youtube_video_ids] << url.split('embed/').last.split('?').first
          end
        end

        result[:screenshot_urls] = []
        doc.css('.screenshot').each do |node|
          result[:screenshot_urls] << node[:src]
        end

        result[:full_screenshot_urls] = []
        doc.css('.full-screenshot').each do |node|
          result[:full_screenshot_urls] << node[:src]
        end

        node = doc.css('.whatsnew').first
        result[:whats_new] = node.inner_html.strip unless node.nil?

        # Stubbing out for now, can't find them in the redesigned page.
        result[:permissions] = permissions = []

        result[:reviews] = []
        doc.css('.single-review').each do |node|
          review = {}
          review[:author_name] = node.css('.author-name').text.strip if node.css('.author-name')
          raw_tag = node.css('.current-rating').to_s
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
          if node.css('.review-title')
            review[:review_title] = node.css('.review-title').text.strip
          end
          if node.css('.review-body')
            review[:review_text] = node.css('.review-body').text
              .sub!(review[:review_title],'')
              .sub!(node.css('.review-link').text,'')
              .strip
          end
          if review
            result[:reviews] << review
          end
        end

        result[:rating_distribution] = { 5 => nil, 4 => nil, 3 => nil, 2 => nil, 1 => nil }

        histogram = doc.css('div.rating-histogram')
        cur_index = 5
        %w(five four three two one).each do |slot|
          node = histogram.css(".#{slot.to_s}")
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
            raise MarketBot::AppNotFoundError.new("Unable to find app in store: #{codes}")
          else
            raise MarketBot::ResponseError.new("Unhandled response: #{codes}")
          end
        end
      end

      def update_callback(result)
        unless @error
          MARKET_ATTRIBUTES.each do |a|
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
