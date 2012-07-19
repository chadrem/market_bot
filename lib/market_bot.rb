require 'uri'

require 'typhoeus'
require 'nokogiri'

require 'market_bot/android/app'
require 'market_bot/android/leaderboard/constants'
require 'market_bot/android/leaderboard'
require 'market_bot/android/search_query'
require 'market_bot/android/developer'

module MarketBot
  def self.hydra
    @hydra ||= Typhoeus::Hydra.new(:max_concurrency => 5)
  end
end
