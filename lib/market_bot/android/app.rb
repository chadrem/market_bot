module MarketBot
  module Android

    class App
      MARKET_ATTRIBUTES = [:title, :rating, :updated, :current_version, :requires_android,
                          :category, :installs, :size, :price, :content_rating, :description,
                          :votes, :developer, :more_from_developer, :users_also_installed,
                          :related]

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

        result[:description] = doc.css('#doc-original-text').first.text
        result[:title] = doc.title.gsub(/ - Android Market$/, '')

        rating_elem = doc.css('.average-rating-value')
        result[:rating] = rating_elem.first.text unless rating_elem.empty?

        votes_elem = doc.css('.votes')
        result[:votes] = doc.css('.votes').first.text unless votes_elem.empty?

        result[:developer] = doc.css('.doc-header-link').first.text

        result[:more_from_developer] = []
        result[:users_also_installed] = []
        result[:related] = []

        if similar_elem = doc.css('.doc-similar').first
          similar_elem.children.each do |similar_elem_child|
            assoc_app_type = similar_elem_child.attributes['data-analyticsid'].text

            next unless %w(more-from-developer users-also-installed related).include?(assoc_app_type)

            assoc_app_type = assoc_app_type.gsub('-', '_').to_sym
            result[assoc_app_type] ||= []

            similar_elem_child.css('.app-left-column-related-snippet-container').each do |app_elem|
              assoc_app = {}

              assoc_app[:app_id] = app_elem.attributes['data-docid'].text

              result[assoc_app_type] << assoc_app
            end
          end
        end

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
