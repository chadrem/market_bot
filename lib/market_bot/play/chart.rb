module MarketBot
  module Play
    class Chart
      attr_reader :collection
      attr_reader :category
      attr_reader :country
      attr_reader :lang
      attr_reader :result

      def self.parse(html, opts = {})
        opts[:lang] ||= MarketBot::Play::DEFAULT_LANG

        results = []
        doc = Nokogiri::HTML(html)

        doc.css('.card').each do |snippet_node|
          result = {}

          details_node = snippet_node.css('.details')

          unless snippet_node.css('img').empty?
            result[:icon_url] = MarketBot::Util.fix_content_url(snippet_node.css('img').first.attributes['src'].value)
          end

          if snippet_node.css('.current-rating').empty?
            result[:stars] = nil
          else
            stars_style = snippet_node.css('.current-rating').first.attributes['style'].value
            stars_width_percent = stars_style[/width:\s+([0-9.]+)%/, 1].to_f
            result[:stars] = (5 * stars_width_percent / 100).round(1).to_s
          end

          title_node = details_node.css('.title').first
          result[:title] = title_node.attributes['title'].to_s
          result[:rank] = title_node.text.gsub(/\..*/, '').to_i

          if (price_elem = details_node.css('.buy span').first)
            result[:price] = price_elem.text
          end

          result[:developer] = details_node.css('.subtitle').first.attributes['title'].to_s
          result[:package] = details_node.css('.title').first.attributes['href'].to_s.gsub('/store/apps/details?id=', '').gsub(/&feature=.*$/, '')
          result[:store_url] = "https://play.google.com/store/apps/details?id=#{result[:package]}&hl=#{opts[:lang]}"

          result[:price] = '0' if result[:price] == 'Free'

          results << result
        end

        results
      end

      def initialize(collection, category = nil, opts = {})
        @collection = collection
        @category = category
        @request_opts = MarketBot::Util.build_request_opts(opts[:request_opts])
        @lang = opts[:lang] || MarketBot::Play::DEFAULT_LANG
        @country = opts[:country] || MarketBot::Play::DEFAULT_COUNTRY
        @max_pages = opts[:max_pages] || MarketBot::Play::Chart::MAX_PAGES
      end

      def store_urls
        urls = []
        start = 0
        num = 100

        @max_pages.times do |_i|
          url = 'https://play.google.com/store/apps'
          url << "/category/#{@category}" if @category
          url << "/collection/#{@collection}?"
          url << "start=#{start}&"
          url << "gl=#{@country}&"
          url << "num=#{num}&"
          url << "hl=#{@lang}"

          urls << url
          start += num
        end

        urls
      end

      def update(_opts = {})
        @result = []

        store_urls.each do |url|
          req = Typhoeus::Request.new(url, @request_opts)
          req.run

          break unless response_handler(req.response)
        end

        @result.flatten!

        self
      end

      private

      def response_handler(response)
        if response.success?
          r = self.class.parse(response.body, lang: @lang)

          if @result.empty? || (!@result.empty? && r[0] && @result[-1][-1][:rank] + 1 == r[0][:rank])
            @result << r
            return true
          end

          false
        else
          codes = "code=#{response.code}, return_code=#{response.return_code}"
          raise MarketBot::ResponseError, "Unhandled response: #{codes}"
        end
      end
    end
  end
end
