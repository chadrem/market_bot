module MarketBot
  module Android

    # Developer pages are extremely similar to leaderboard pages.
    # Amazingly, this inheritence hack works!
    class Developer < MarketBot::Android::Leaderboard
      def initialze(developer, options={})
        super(query, nil, options)
      end

      def market_urls(options={})
        results = []

        min_page = options[:min_page] || 1
        max_page = options[:max_page] || 25

        (min_page..max_page).each do |page|
          start_val = (page - 1) * 12

          url = "https://play.google.com/store/apps/developer?"
          url << "id=#{URI.escape(identifier)}&"
          url << "start=#{start_val}&"
          url << "num=12&hl=en"

          results << url
        end

        results
      end
    end

  end
end
