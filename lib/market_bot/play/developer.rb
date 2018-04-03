module MarketBot
  module Play
    class Developer < MarketBot::Play::Chart
      def initialize(developer, options = {})
        super(developer, nil, options)
      end

      def store_urls(_options = {})
        results = []
        num = 100

        url = 'https://play.google.com/store/apps/developer?'
        url << "id=#{CGI.escape(@collection)}&"
        url << 'start=0&'
        url << "gl=#{@country}&"
        url << "num=#{num}&"
        url << "hl=#{@lang}"

        results << url

        results
      end

      def update(opts = {})
        super(opts)
        @result.each { |r| r.delete(:rank) }

        self
      end
    end
  end
end
