module MarketBot
  module Movie

    class Leaderboard
      attr_reader :identifier, :category
      attr_reader :hydra

      MAX_STARS = 5
      PERCENT_DENOM = 100

      def self.parse(html)
        results = []
        doc = Nokogiri::HTML(html)

        doc.css('.card-list').each do |snippet_node|
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

          result[:genre] = details_node.css('.subtitle').first.attributes['title'].to_s
          movie_detail_url = details_node.css('.title').first.attributes['href'].to_s.gsub('/store/movies/details', '')
          result[:market_id]  = movie_detail_url.split('?id=').last
          result[:market_url] = "https://play.google.com/store/movies/details#{movie_detail_url}&hl=en"

          result[:price_usd] = '$0.00' if result[:price_usd] == 'Install'

          results << result
        end

        results
      end

      # This is the initializer method for the Leaderboard class.
      #
      # Leaderboard gets initialized by default with a specified identifier, an optional movies category, along with optional
      # request options.
      #
      # * *Args*    :
      #   - +identifier+ -> The identifier is used to get the results for distinct leaderboards.
      #                     Valid identifiers include:
      #                           :topselling_paid
      #                           :topselling_paid_show
      #   - +category+ -> The category switches between the actual categories, or genres, of movies within a given leaderboard.
      #                   Valid categories include:
      #
      #                  :action_and_adventure,
      #                  :animation,
      #                  :classics,
      #                  :comedy,
      #                  :crime,
      #                  :documentary,
      #                  :drama,
      #                  :family,
      #                  :horror,
      #                  :independent,
      #                  :indian_cinema,
      #                  :music,
      #                  :sci_fi_and_fantasy,
      #                  :short_films,
      #                  :sports,
      #                  :world_cinema
      ##   - +options+ -> The optional options Hash contains keys :hydra and :request_opts. :hydra can be used to specify
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
        country  = options[:country]  || 'us'

        (min_page..max_page).each do |page|
          start_val = (page - 1) * 24

          url = 'https://play.google.com/store/movies'
          url << "/category/#{category.to_s.upcase}" if category
          url << "/collection/#{identifier.to_s}?"
          url << "start=#{start_val}&"
          url << "gl=#{country}&"
          url << "num=24&hl=en"

          results << url
        end

        results
      end

      def enqueue_update(options={},&block)
        @callback = block
        min_rank = options[:min_rank] || 1
        max_rank = options[:max_rank] || 500
        country  = options[:country]  || 'us'

        min_page = rank_to_page(min_rank)
        max_page = rank_to_page(max_rank)

        @parsed_results = []

        urls = market_urls(:min_page => min_page, :max_page => max_page, :country => country)
        urls.each_index{ |i| process_page(urls[i], i+1) }

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
