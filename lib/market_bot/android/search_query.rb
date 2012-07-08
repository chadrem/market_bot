module MarketBot
  module Android

    class SearchQuery
      attr_reader :query
      attr_reader :hydra

      def self.parse(html)
        # Search queries use the same format as Leaderboards.  w00t!
        Leaderboard.parse(html)
      end

      def initialize(query, options={})
        @query = query
        @hydra = options[:hydra] || Typhoeus::Hydra.hydra
        @parsed_results = []
      end

      def market_urls(options={})
        results = []

        min_page = options[:min_page] || 1
        max_page = options[:max_page] || 25

        (min_page..max_page).each do |page|
          start_val = (page - 1) * 24

          url = "https://play.google.com/store/search?"
          url << "q=#{URI.escape(query)}&"
          url << "c=apps&start=#{start_val}&"
          url << "num=24"

          results << url
        end

        results
      end

      def enqueue_update(options={})
        min_rank = options[:min_rank] || 1
        max_rank = options[:max_rank] || 500

        min_page = rank_to_page(min_rank)
        max_page = rank_to_page(max_rank)

        @parsed_results = []

        urls = market_urls(:min_page => min_page, :max_page => max_page)
        urls.each_index{ |i| process_page(urls[i], i+1) }
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
        request = Typhoeus::Request.new(url)
        request.on_complete do |response|
          result = SearchQuery.parse(response.body)
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
