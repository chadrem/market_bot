module MarketBot
  module Play
    class App
      ATTRIBUTES = %i[
        category
        category_url
        categories
        categories_urls
        contains_ads
        content_rating
        cover_image_url
        current_version
        description
        developer
        developer_id
        email
        full_screenshot_urls
        html
        in_app_products_price
        physical_address
        installs
        more_from_developer
        price
        rating
        rating_distribution
        requires_android
        reviews
        screenshot_urls
        similar
        size
        title
        updated
        votes
        website_url
        privacy_url
        whats_new
      ].freeze
    end
  end
end
