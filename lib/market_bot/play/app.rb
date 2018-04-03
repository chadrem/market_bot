module MarketBot
  module Play
    class App
      attr_reader *ATTRIBUTES
      attr_reader :package
      attr_reader :lang
      attr_reader :result

      def self.parse(html, opts = {})
        result = {}

        doc = Nokogiri::HTML(html)

        h2_additional_info = doc.at('h2:contains("Additional Information")')
        if h2_additional_info
          additional_info_parent         = h2_additional_info.parent.next.children.children
          node                           = additional_info_parent.at('div:contains("Updated")')
          result[:updated]               = node.children[1].text if node
          node                           = additional_info_parent.at('div:contains("Size")')
          result[:size]                  = node.children[1].text if node
          node                           = additional_info_parent.at('div:contains("Installs")')
          result[:installs]              = node.children[1].text if node
          node                           = additional_info_parent.at('div:contains("Current Version")')
          result[:current_version]       = node.children[1].text if node
          node                           = additional_info_parent.at('div:contains("Requires Android")')
          result[:requires_android]      = node.children[1].text if node
          node                           = additional_info_parent.at('div:contains("In-app Products")')
          result[:in_app_products_price] = node.children[1].text if node

          developer_div = additional_info_parent.xpath('div[./text()="Developer"]').first.parent
          unless developer_div
            developer_div = additional_info_parent.at('div:contains("Contact Developer")')
          end
          if developer_div
            node = developer_div.at('a:contains("Visit website")')
            if node
              href = node.attr('href')
              encoding_options = {
                invalid: :replace,      # Replace invalid byte sequences
                undef: :replace,        # Replace anything not defined in ASCII
                replace: '',            # Use a blank for those replacements
                universal_newline: true # Always break lines with \n
              }

              href = href.encode(Encoding.find('ASCII'), encoding_options)
              href_q = URI(href).query
              if href_q
                q_param = href_q.split('&').select {|p| p =~ /q=/}.first
                href    = q_param.gsub('q=', '') if q_param
              end
              result[:website_url] = href
            end

            result[:email] = developer_div.at('a:contains("@")').text

            node = developer_div.at('a:contains("Privacy Policy")')
            if node
              href             = node.attr('href')
              encoding_options = {
                invalid: :replace,      # Replace invalid byte sequences
                undef: :replace,        # Replace anything not defined in ASCII
                replace: '',            # Use a blank for those replacements
                universal_newline: true # Always break lines with \n
              }

              href   = href.encode(Encoding.find('ASCII'), encoding_options)
              href_q = URI(href).query
              if href_q
                q_param = href_q.split('&').select {|p| p =~ /q=/}.first
                href    = q_param.gsub('q=', '') if q_param
              end
              result[:privacy_url] = href

              node                      = node.parent.next
              result[:physical_address] = node.text if node
            end
          end
        end

        a_genres              = doc.search('a[itemprop="genre"]')
        a_genre               = a_genres[0]

        result[:categories]      = a_genres.map {|d| d.text.strip}
        result[:categories_urls] = a_genres.map {|d| File.split(d["href"])[1]}

        result[:category]     = result[:categories].first
        result[:category_url] = result[:categories_urls].first

        span_dev               = a_genre.parent.previous
        result[:developer]     = span_dev.children[0].text
        result[:developer_url] = span_dev.children[0].attr('href')
        result[:developer_id]  = result[:developer_url].split('?id=').last.strip

        result[:content_rating] = a_genre.parent.parent.next.text

        result[:price]          = doc.at_css('meta[itemprop="price"]')[:content] if doc.at_css('meta[itemprop="price"]')

        result[:contains_ads] = !!doc.at('div:contains("Contains Ads")')

        result[:description]  = doc.at_css('div[itemprop="description"]').inner_html.strip if doc.at_css('div[itemprop="description"]')
        result[:title]        = doc.at_css('h1[itemprop="name"]').text

        if doc.at_css('meta[itemprop="ratingValue"]')
          node            = doc.at_css('meta[itemprop="ratingValue"]')
          result[:rating] = node[:content].strip
          node            = doc.at_css('meta[itemprop="ratingCount"]')
          result[:votes]  = node[:content].strip.to_i
        end

        a_similar = doc.at_css('a:contains("Similar")')
        if a_similar
          similar_divs     = a_similar.parent.parent.parent.next.children
          result[:similar] = similar_divs.search('a').select {|a|
            a["href"].start_with?('/store/apps/details')
          }.map {|a|
            {package: a["href"].split('?id=').last.strip}
          }.compact.uniq
        end

        h2_more = doc.at_css("h2:contains(\"#{result[:developer]}\")")
        if h2_more
          more_divs                    = h2_more.parent.next.children
          result[:more_from_developer] = more_divs.search('a').select {|a|
            a["href"].start_with?('/store/apps/details')
          }.map {|a|
            {package: a["href"].split('?id=').last.strip}
          }.compact.uniq
        end

        node = doc.at_css('img[alt="Cover art"]')
        unless node.nil?
          url                      = MarketBot::Util.fix_content_url(node[:src])
          result[:cover_image_url] = url
        end

        nodes                    = doc.search('img[alt="Screenshot Image"]')
        result[:screenshot_urls] = []
        unless node.nil?
          result[:screenshot_urls] = nodes.map {|node|
            url                      = MarketBot::Util.fix_content_url(node[:src])
            result[:cover_image_url] = url
          }
        end

        node               = doc.at_css('h2:contains("What\'s New")')
        result[:whats_new] = node.inner_html if node

        result[:html] = html

        result
      end

      def initialize(package, opts = {})
        @package      = package
        @lang         = opts[:lang] || MarketBot::Play::DEFAULT_LANG
        @country      = opts[:country] || MarketBot::Play::DEFAULT_COUNTRY
        @request_opts = MarketBot::Util.build_request_opts(opts[:request_opts])
      end

      def store_url
        "https://play.google.com/store/apps/details?id=#{@package}&hl=#{@lang}&gl=#{@country}"
      end

      def update
        req = Typhoeus::Request.new(store_url, @request_opts)
        req.run
        response_handler(req.response)

        self
      end

      private

      def response_handler(response)
        if response.success?
          @result = self.class.parse(response.body)

          ATTRIBUTES.each do |a|
            attr_name  = "@#{a}"
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
