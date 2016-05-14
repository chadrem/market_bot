module MarketBot
  module Play
    class Developer < MarketBot::Play::Chart
      def initialize(developer, options={})
        super(developer, nil, options)
      end

      def market_urls(options={})
        results = []

        country = options[:country] || 'us'

        url = "https://play.google.com/store/apps/developer?"
        url << "id=#{URI.escape(identifier)}&"
        url << "gl=#{country}&"
        url << "hl=en"

        results << url

        return results
      end
    end
  end
end
