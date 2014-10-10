module MarketBot
  module Android

    class Leaderboard
      attr_reader :identifier, :category
      attr_reader :hydra

      MAX_STARS = 5
      PERCENT_DENOM = 100

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

        doc.css('.card').each do |snippet_node|
          result = {}

          details_node = snippet_node.css('.details')

          unless snippet_node.css('.current-rating').empty?
            stars_style = snippet_node.css('.current-rating').first.attributes['style'].value
            stars_width_percent = stars_style[/width:\s+([0-9.]+)%/, 1].to_f
            result[:stars] = (MAX_STARS * stars_width_percent/PERCENT_DENOM).round(1).to_s
          else
            result[:stars] = nil
          end

          result[:title] = details_node.css('.title').first.attributes['title'].to_s

          if (price_elem = details_node.css('.buy span').first)
            result[:price_usd] = price_elem.text
          end

          result[:developer] = details_node.css('.subtitle').first.attributes['title'].to_s
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

      # This is the initializer method for the Leaderboard class.
      #
      # Leaderboard gets initialized by default with a specified identifier, an optional app category, along with optional
      # request options.
      #
      # * *Args*    :
      #   - +identifier+ -> The identifier is used to get the results for distinct leaderboards.
      #                     Valid identifiers include:
      #                           :topselling_paid
      #                           :topselling_free
      #                           :topselling_new_free
      #                           :topselling_new_paid
      #                           :editors_choice
      #                           :topselling_paid_game
      #                           :movers_shakers
      #                           :featured
      #                           :tablet_featured
      #                           :topgrossing
      #   - +category+ -> The category switches between the actual categories, or genres, of apps within a given leaderboard.
      #                   Valid categories include:
      #                           :game
      #                           :arcade
      #                           :brain
      #                           :cards
      #                           :casual
      #                           :game_wallpaper
      #                           :racing
      #                           :sports_games
      #                           :game_widgets
      #                           :application
      #                           :books_and_reference
      #                           :business
      #                           :comics
      #                           :communication
      #                           :education
      #                           :entertainment
      #                           :finance
      #                           :health_and_fitness
      #                           :libraries_and_demo
      #                           :lifestyle
      #                           :app_wallpaper
      #                           :media_and_video
      #                           :medical
      #                           :music_and_audio
      #                           :news_and_magazines
      #                           :personalization
      #                           :photography
      #                           :productivity
      #                           :shopping
      #                           :social
      #                           :sports
      #                           :tools
      #                           :transportation
      #                           :travel_and_local
      #                           :weather
      #                           :app_widgets
      #   - +options+ -> The optional options Hash contains keys :hydra and :request_opts. :hydra can be used to specify
      #                   a custom Hydra instance, while :request_opts is a Hash containing further options for the Play
      #                   Store HTTP request.
      #
      def initialize(identifier, category=nil, options={})
        @identifier = identifier
        @category = category
        @hydra = options[:hydra] || MarketBot.hydra
        @request_opts = options[:request_opts] || {}
        @parsed_results = []
        @pending_pages = []
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

      def enqueue_update(options={},&block)
        @callback = block
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
        @pending_pages << page_num
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
        @pending_pages.delete(page)
        @callback.call(self) if @callback and @pending_pages.empty?
      end
    end

  end
end
