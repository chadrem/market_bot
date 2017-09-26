module MarketBot
  module Play
    class Search < MarketBot::Play::Chart
      def initialize(query, options={})
        super(query, nil, options)
      end

      def store_urls(options={})
        results = []
        num = 100

        url = "https://play.google.com/store/search?"
        url << "q=#{URI.escape(@collection)}&"
        url << "c=apps&"
        url << "gl=#{@country}&"
        url << "hl=#{@lang}"

        results << url

        return results
      end

      def update(opts={})
        super(opts)
        @result.each { |r| r.delete(:rank) }

        self
      end
    end
  end
end
