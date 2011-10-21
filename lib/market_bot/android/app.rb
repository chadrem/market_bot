module MarketBot
  module Android

    class App
      MARKET_ATTRIBUTES = [:title, :rating, :updated, :current_version, :requires_android,
                          :category, :installs, :size, :price, :content_rating, :description,
                          :votes]

      attr_reader :app_id
      attr_reader *MARKET_ATTRIBUTES
      attr_reader :hydra

      def self.parse(html)
        result = {}

        doc = Nokogiri::HTML(html)

        elements = doc.css('.doc-metadata').first.elements[2].elements
        elem_count = elements.count

        (3..(elem_count - 1)).select{ |n| n.odd? }.each do |i|
          field_name  = elements[i].text

          case field_name
          when 'Updated:'
            result[:updated] = elements[i + 1].text
          when 'Current Version:'
            result[:current_version] = elements[i + 1].text
          when 'Requires Android:'
            result[:requires_android] = elements[i + 1].text
          when 'Category:'
            result[:category] = elements[i + 1].text
          when 'Installs:'
            result[:installs] = elements[i + 1].children.first.text
          when 'Size:'
            result[:size] = elements[i + 1].text
          when 'Price:'
            result[:price] = elements[i + 1].text
          when 'Content Rating:'
            result[:content_rating] = elements[i + 1].text
          end
        end

        result[:rating]      = doc.css('.average-rating-value').first.text
        result[:description] = doc.css('#doc-original-text').first.text
        result[:votes]       = doc.css('.votes').first.text
        result[:title]       = doc.title.gsub(/ - Android Market$/, '')

        result
      end

      def initialize(app_id, options={})
        @app_id = app_id
        @hydra = options[:hydra] || Typhoeus::Hydra.hydra
      end

      def market_url
        "https://market.android.com/details?id=#{@app_id}"
      end

      def update
        resp = Typhoeus::Request.get(market_url)
        result = App.parse(resp.body)
        update_callback(result)

        self
      end

      def enqueue_update
        request = Typhoeus::Request.new(market_url)
        request.on_complete do |response|
          result = App.parse(response.body)
          update_callback(result)
        end
        hydra.queue(request)

        self
      end

    private
      def update_callback(result)
        MARKET_ATTRIBUTES.each do |a|
          attr_name = "@#{a}"
          attr_value = result[a]
          instance_variable_set(attr_name, attr_value)
        end
      end
    end

  end
end
