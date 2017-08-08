module MarketBot
  module Play
    class App
      attr_reader *ATTRIBUTES
      attr_reader :package
      attr_reader :lang
      attr_reader :result

      def initialize(package, opts={})
        @package = package
        @lang = opts[:lang] || MarketBot::Play::DEFAULT_LANG
        @country = opts[:country] || MarketBot::Play::DEFAULT_COUNTRY
        @request_opts = MarketBot::Util.build_request_opts(opts[:request_opts])
      end

      def self.parse(html, package, opts={})
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

        result[:content_rating] = doc.at_css("div.content[itemprop='contentRating']").text if doc.at_css("div.content[itemprop='contentRating']")

        result[:price] = doc.at_css('meta[itemprop="price"]')[:content] if doc.at_css('meta[itemprop="price"]')

        category_div = doc.at_css('.category')
        result[:category] = category_div.text.strip
        result[:category_url] = File.split(category_div["href"])[1]

        result[:description] = doc.at_css('div[itemprop="description"]').inner_html.strip
        result[:title] = doc.at_css('div.id-app-title').text

        score = doc.at_css('.score-container')
        unless score.nil?
          node  = score.at_css('.score')
          result[:rating] = node.text.strip
          node = score.at_css('meta[itemprop="ratingCount"]')
          result[:votes] = node[:content].strip.to_i
        end

        node = doc.at_css('div[itemprop="author"]')
        result[:developer] = node.at_css('.primary').text.strip
        result[:developer_id] = node.at_css('.primary').attr('href').split('?id=').last.strip

        result[:more_from_developer] = []
        result[:similar] = []

        node = doc.css('.recommendation')
        node.css('.rec-cluster').each do |recommended|
          assoc_app_type = recommended.at_css('.heading').text.strip.eql?('Similar' ) ? :similar : :more_from_developer
          recommended.css('.card').each do |card|
            assoc_app = {}
            assoc_app[:package] = card['data-docid'].strip

            result[assoc_app_type] << assoc_app
          end
        end

        node = doc.at_css('.cover-image')
        unless node.nil?
          url = MarketBot::Util.fix_content_url(node[:src])
          result[:cover_image_url] = url
        end

        result[:screenshot_urls] = []
        doc.css('.screenshot').each do |node|
          result[:screenshot_urls] << MarketBot::Util.fix_content_url(node[:src])
        end

        result[:full_screenshot_urls] = []
        doc.css('.full-screenshot').each do |node|
          result[:full_screenshot_urls] << MarketBot::Util.fix_content_url(node[:src])
        end

        if (node = doc.at_css('.recent-change'))
          result[:whats_new] = node.inner_html
        end

        result[:reviews] = []
        unless opts[:skip_reviews] # Review parsing is CPU intensive.
          doc.css('.single-review').each do |node|
            review = {}
            review[:author] = node.at_css('.author-name').text.strip if node.at_css('.author-name')
            raw_tag = node.at_css('.current-rating').to_s
            if raw_tag.match(/100%;/i)
              review[:score] = 5
            elsif raw_tag.match(/80%;/i)
              review[:score] = 4
            elsif raw_tag.match(/60%;/i)
              review[:score] = 3
            elsif raw_tag.match(/40%;/i)
              review[:score] = 2
            elsif raw_tag.match(/20%;/i)
              review[:score] = 1
            end
            if node.at_css('.review-title')
              review[:title] = node.at_css('.review-title').text.strip
            end
            if node.at_css('.review-body')
              review[:text] = node.at_css('.review-body').text
                .sub!(review[:title],'')
                .sub!(node.at_css('.review-link').text, '')
                .strip
            end
            if node.at_css('.review-date')
              review[:created_at] = node.at_css('.review-date').text.strip
            end
            if review
              result[:reviews] << review
            end
          end
        end

        result[:rating_distribution] = { 5 => nil, 4 => nil, 3 => nil, 2 => nil, 1 => nil }

        if (histogram = doc.at_css('div.rating-histogram'))
          cur_index = 5
          %w(five four three two one).each do |slot|
            node = histogram.at_css(".#{slot.to_s}")
            result[:rating_distribution][cur_index] = node.css('.bar-number').text.gsub(/,/,'').to_i
            cur_index -= 1
          end
        else
          result[:rating_distribution] = nil
        end

        result[:html] = html

        result[:permissions] = []
        _agent = Mechanize.new
        _page = _agent.post('https://play.google.com/store/xhr/getdoc?authuser=0',
                            { 'ids' => package,
                              'hl' => 'en',
                              'remember' => '1',
                              'xhr' => 1
                            })
        my_hash = JSON.parse(_page.body.lines[2..-1].join)
        my_hash = my_hash[0][2][0][65]
        h1 = my_hash[my_hash.keys[0]][23][0]
        h2 = my_hash[my_hash.keys[0]][23][1]
        h3 = my_hash[my_hash.keys[0]][23][2]
        h4 = my_hash[my_hash.keys[0]][23][3]

        h1.each_with_index do |n, _i|
          n[1].each_with_index do |_n, _i|
            result[:permissions] << _n[0]
          end
        end
        h2.each_with_index do |n, _i|
          n[1].each_with_index do |_n, _i|
            result[:permissions] << _n[0]
          end
        end
        h3.each_with_index do |n, _i|
          result[:permissions] << n[0]
        end
        result[:permissions].uniq!

        result
      end

      def store_url
        "https://play.google.com/store/apps/details?id=#{@package}&hl=#{@lang}&gl=#{@country}"
      end

      def update(package)
        req = Typhoeus::Request.new(store_url, @request_opts)
        req.run
        response_handler(req.response, package)

        self
      end

      private

      def response_handler(response, package)
        if response.success?
          @result = self.class.parse(response.body, package)

          ATTRIBUTES.each do |a|
            attr_name = "@#{a}"
            attr_value = @result[a]
            instance_variable_set(attr_name, attr_value)
          end
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
    end
  end
end
