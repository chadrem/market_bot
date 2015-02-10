require 'uri'

require 'typhoeus'
require 'nokogiri'

require 'market_bot/version'
require 'market_bot/exceptions'
require 'market_bot/android/app'
require 'market_bot/android/leaderboard/constants'
require 'market_bot/android/leaderboard'
require 'market_bot/android/search_query'
require 'market_bot/android/developer'
require 'market_bot/movie/leaderboard'
require 'market_bot/movie/search_query'

module MarketBot
  def self.hydra
    @hydra ||= Typhoeus::Hydra.new(:max_concurrency => 5)
  end
end

