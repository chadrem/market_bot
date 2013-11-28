module MarketBot
  module Android

    class App
      MARKET_ATTRIBUTES = [:title, :rating, :updated, :current_version, :requires_android,
                          :category, :installs, :size, :price, :content_rating, :description,
                          :votes, :developer, :more_from_developer, :users_also_installed,
                          :related, :banner_icon_url, :banner_image_url, :website_url, :email,
                          :youtube_video_ids, :screenshot_urls, :whats_new, :permissions,
                          :rating_distribution, :html]

      attr_reader :app_id
      attr_reader *MARKET_ATTRIBUTES
      attr_reader :hydra
      attr_reader :callback
      attr_reader :error

      def self.parse(html)
        result = {}

        doc = Nokogiri::HTML(html)
        meta_info = doc.css('.meta-info')
        meta_info.each do |info|
          field_name = info.css('.title').text.strip

          case field_name
            when 'Updated'
              result[:updated] = info.css('.content').text.strip
            when 'Installs'
              result[:installs] = info.css('.content').text.strip
            when 'Size'
              result[:size] = info.css('.content').text.strip
            when 'Current Version'
              result[:current_version] = info.css('.content').text.strip
            when 'Requires Android'
              result[:requires_android] = info.css('.content').text.strip
            when 'Content Rating'
              result[:content_rating] = info.css('.content').text.strip
            when 'Contact Developer'
              info.css('.dev-link').each do |node|
                if node.text.strip.eql? 'Email Developer'
                  result[:email] = node[:href].gsub(/^mailto:/,'')
                else
                  redirect_url = node[:href]
                  if q_param = URI(redirect_url).query.split('&').select{ |p| p =~ /q=/ }.first
                    actual_url = q_param.gsub('q=', '')
                  end

                  result[:website_url] = actual_url
                end
              end

          end
        end

        node = doc.xpath("//meta[@itemprop='price']").first
        result[:price] = node[:content].strip rescue 'Free'

        result[:category] = doc.css('.category').first.text.strip rescue ''
        result[:description] = doc.xpath("//div[@itemprop='description']").first.inner_html.strip
        result[:title] = doc.xpath("//div[@itemprop='name']").first.text.strip

        score = doc.css('.score-container').first
        unless score.nil?
          node  = score.css('.score').first
          result[:rating] = node.text.strip
          node = score.xpath("//meta[@itemprop='ratingCount']").first
          result[:votes] = node[:content].strip
        end

        node = doc.xpath("//div[@itemprop='author']")
        result[:developer] = node.css('.primary').first.text.strip

        result[:more_from_developer] = []
        result[:users_also_installed] = []
        result[:related] = []

        node = doc.css('.recommendation')
        node.css('.rec-cluster').each do |recommended|
          assoc_app_type = recommended.css('.heading').first.text.strip.eql?('Similar' ) ? :related : :more_from_developer
          recommended.css('.card').each do |card|
            assoc_app = {}
            assoc_app[:app_id] = card['data-docid'].strip

            result[assoc_app_type] << assoc_app
          end
        end
        # Users also installed is no longer on the page, adding this for backwards compatibility, well, sort of....
        result[:users_also_installed] = result[:related]

        node = doc.css('.cover-image').first
        unless node.nil?
          result[:banner_icon_url] = node[:src]
          result[:banner_image_url] = node[:src]
        end

        result[:youtube_video_ids] = []
        doc.css('.play-action-container').each do |node|
          url = node['data-video-url']
          unless url.nil?
            result[:youtube_video_ids] << url.split('embed/').last.split('?').first
          end
        end

        result[:screenshot_urls] = []
        doc.css('.screenshot').each do |node|
          result[:screenshot_urls] << node[:src]
        end

        node = doc.css('.whatsnew').first
        result[:whats_new] = node.inner_html.strip unless node.nil?

        # Stubbing out for now, can't find them in the redesigned page.
        result[:permissions] = permissions = []

        result[:rating_distribution] = { 5 => nil, 4 => nil, 3 => nil, 2 => nil, 1 => nil }

        histogram = doc.css('div.rating-histogram')
        cur_index = 5
        %w(five four three two one).each do |slot|
          node = histogram.css(".#{slot.to_s}")
          result[:rating_distribution][cur_index] = node.css('.bar-number').text.gsub(/,/,'').to_i
          cur_index -= 1

        end

        result[:html] = html

        result
      end

      def initialize(app_id, options={})
        @app_id = app_id
        @hydra = options[:hydra] || MarketBot.hydra
        @request_opts = options[:request_opts] || {}
        @callback = nil
        @error = nil
      end

      def market_url
        "https://play.google.com/store/apps/details?id=#{@app_id}&hl=en"
      end

      def update
        resp = Typhoeus::Request.get(market_url, @request_opts)
        result = App.parse(resp.body)
        update_callback(result)

        self
      end

      def enqueue_update(&block)
        @callback = block
        @error = nil

        request = Typhoeus::Request.new(market_url, @request_opts)

        request.on_complete do |response|
          # HACK: Typhoeus <= 0.4.2 returns a response, 0.5.0pre returns the request.
          response = response.response if response.is_a?(Typhoeus::Request)

          result = nil

          begin
            result = App.parse(response.body)
          rescue Exception => e
            @error = e
          end

          update_callback(result)
        end

        hydra.queue(request)

        self
      end

    private
      def update_callback(result)
        unless @error
          MARKET_ATTRIBUTES.each do |a|
            attr_name = "@#{a}"
            attr_value = result[a]
            instance_variable_set(attr_name, attr_value)
          end
        end

        @callback.call(self) if @callback
      end
    end

  end
end
