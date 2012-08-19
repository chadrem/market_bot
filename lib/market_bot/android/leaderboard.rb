module MarketBot
  module Android

    class Leaderboard
      attr_reader :identifier, :category
      attr_reader :hydra

      def self.parse(html)
        if html.include?('<title>Editor&#39;s Choice')
          parse_editors_choice_page(html)
        else
          parse_normal_page(html)
        end
      end

      def self.parse_normal_page(html)
        results = []
        doc = Nokogiri::HTML(html)

        doc.css('.snippet').each do |snippet_node|
          result = {}

          details_node = snippet_node.css('.details')

          unless snippet_node.css('.ratings').empty?
            stars_text = snippet_node.css('.ratings').first.attributes['title'].value
            result[:stars] = /Rating: (.+) stars .*/.match(stars_text)[1]
          else
            result[:stars] = nil
          end

          result[:title] = details_node.css('.title').first.attributes['title'].to_s
          result[:price_usd] = details_node.css('.buy-button-price').children.first.text.gsub(' Buy', '')
          result[:developer] = details_node.css('.attribution').children.first.text
          result[:market_id] = details_node.css('.title').first.attributes['href'].to_s.gsub('/store/apps/details?id=', '').gsub(/&feature=.*$/, '')
          result[:market_url] = "https://play.google.com/store/apps/details?id=#{result[:market_id]}&hl=en"

          result[:price_usd] = '$0.00' if result[:price_usd] == 'Install'

          results << result
        end

        results
      end

      def self.parse_editors_choice_page(html)
        results = []

        doc = Nokogiri::HTML(html)

        doc.css('.fsg-snippet').each do |snippet_node|
          result = {}

          result[:title]      = snippet_node.css('.title').text
          result[:price_usd]  = nil
          result[:developer]  = snippet_node.css('.attribution').text
          result[:market_id]  = snippet_node.attributes['data-docid'].text
          result[:market_url] = "https://play.google.com/store/apps/details?id=#{result[:market_id]}&hl=en"

          results << result
        end

        results
      end

      def initialize(identifier, category=nil, options={})
        @identifier = identifier
        @category = category
        @hydra = options[:hydra] || MarketBot.hydra
        @request_opts = options[:request_opts] || {}
        @parsed_results = []
      end

      def market_urls(options={})
        results = []

        min_page = options[:min_page] || 1
        max_page = options[:max_page] || 25

        (min_page..max_page).each do |page|
          start_val = (page - 1) * 24

          url = 'https://play.google.com/store/apps'
          url << "/category/#{category.to_s.upcase}" if category
          url << "/collection/#{identifier.to_s}?"
          url << "start=#{start_val}"
          url << "&num=24&hl=en"

          results << url
        end

        results
      end

      def enqueue_update(options={})
        if @identifier.to_s.downcase == 'editors_choice' && category == nil
          url = 'https://play.google.com/store/apps/collection/editors_choice?&hl=en'
          process_page(url, 1)
        else
          min_rank = options[:min_rank] || 1
          max_rank = options[:max_rank] || 500

          min_page = rank_to_page(min_rank)
          max_page = rank_to_page(max_rank)

          @parsed_results = []

          urls = market_urls(:min_page => min_page, :max_page => max_page)
          urls.each_index{ |i| process_page(urls[i], i+1) }
        end

        self
      end

      def update(options={})
        enqueue_update(options)
        @hydra.run

        self
      end

      def rank_to_page(rank)
        ((rank - 1) / 24) + 1
      end

      def results
        raise 'Results do not exist yet.' unless @parsed_results
        @parsed_results.reject{ |page| page.nil? || page.empty? }.flatten
      end

    private
      def process_page(url, page_num)
        request = Typhoeus::Request.new(url, @request_opts)
        request.on_complete do |response|
          # HACK: Typhoeus <= 0.4.2 returns a response, 0.5.0pre returns the request.
          response = response.response if response.is_a?(Typhoeus::Request)

          result = Leaderboard.parse(response.body)
          update_callback(result, page_num)
        end
        @hydra.queue(request)
      end

      def update_callback(result, page)
        @parsed_results[page] = result
      end
    end

  end
end
