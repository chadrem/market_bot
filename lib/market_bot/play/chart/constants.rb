module MarketBot
  module Play
    class Chart
      MAX_PAGES = 6

      COLLECTIONS = %w[
        topselling_free
        topselling_paid
        topgrossing
        topselling_free
        movers_shakers
        topgrossing
        topselling_new_free
        topselling_new_paid
      ].freeze

      CATEGORIES = %w[
        ANDROID_WEAR
        BOOKS_AND_REFERENCE
        BUSINESS
        COMICS
        COMMUNICATION
        EDUCATION
        ENTERTAINMENT
        FINANCE
        HEALTH_AND_FITNESS
        LIBRARIES_AND_DEMO
        LIFESTYLE
        APP_WALLPAPER
        MEDIA_AND_VIDEO
        MEDICAL
        MUSIC_AND_AUDIO
        NEWS_AND_MAGAZINES
        PERSONALIZATION
        PHOTOGRAPHY
        PRODUCTIVITY
        SHOPPING
        SOCIAL
        SPORTS
        TOOLS
        TRANSPORTATION
        TRAVEL_AND_LOCAL
        WEATHER
        APP_WIDGETS
        GAME_ACTION
        GAME_ADVENTURE
        GAME_ARCADE
        GAME_BOARD
        GAME_CARD
        GAME_CASINO
        GAME_CASUAL
        GAME_EDUCATIONAL
        GAME_MUSIC
        GAME_PUZZLE
        GAME_RACING
        GAME_ROLE_PLAYING
        GAME_SIMULATION
        GAME_SPORTS
        GAME_STRATEGY
        GAME_TRIVIA
        GAME_WORD
        FAMILY?age=AGE_RANGE1
        FAMILY?age=AGE_RANGE2
        FAMILY?age=AGE_RANGE3
        FAMILY_ACTION
        FAMILY_BRAINGAMES
        FAMILY_CREATE
        FAMILY_EDUCATION
        FAMILY_MUSICVIDEO
        FAMILY_PRETEND
      ].freeze
    end
  end
end
