module MarketBot
  module Android

    class App
      MARKET_ATTRIBUTES = [:title, :rating, :updated, :current_version, :requires_android,
                          :category, :installs, :size, :price, :content_rating, :description]

      attr_reader :app_id
      attr_reader *MARKET_ATTRIBUTES
      attr_reader :hydra

      def self.parse(html)
        result = {}

        doc = Nokogiri::HTML(html)

        result[:title]            = doc.title.gsub(/ - Android Market$/, '')
        result[:rating]           = doc.css('.doc-metadata').first.elements[2].elements[4].text[6]
        result[:updated]          = doc.css('.doc-metadata').first.elements[2].elements[6].text
        result[:current_version]  = doc.css('.doc-metadata').first.elements[2].elements[8].text
        result[:requires_android] = doc.css('.doc-metadata').first.elements[2].elements[10].text
        result[:category]         = doc.css('.doc-metadata').first.elements[2].elements[12].text
        result[:installs]         = doc.css('.doc-metadata').first.elements[2].elements[14].children.first.text
        result[:size]             = doc.css('.doc-metadata').first.elements[2].elements[16].text
        result[:price]            = doc.css('.doc-metadata').first.elements[2].elements[18].text
        result[:content_rating]   = doc.css('.doc-metadata').first.elements[2].elements[20].text
        result[:description]      = doc.css('#doc-original-text').first.text
        result[:votes]            = doc.css('.votes').first.text

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
