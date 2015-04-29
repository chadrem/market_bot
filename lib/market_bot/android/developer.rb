module MarketBot
  module Android

    # Developer pages are extremely similar to leaderboard pages.
    # Amazingly, this inheritence hack works!
    #
    # BUG: This code only retrieves the first page of results.
    #      This means you will only get the first 24 apps for a developer.
    #      Some developers have hundreds of apps so this needs fixed!!!
    class Developer < MarketBot::Android::Leaderboard
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
