require 'uri'
require 'cgi'

require 'typhoeus'
require 'nokogiri'

require 'market_bot/version'
require 'market_bot/exceptions'
require 'market_bot/util'
require 'market_bot/play/constants'
require 'market_bot/play/app/constants'
require 'market_bot/play/app'
require 'market_bot/play/chart/constants'
require 'market_bot/play/chart'
require 'market_bot/play/developer'

module MarketBot
  def self.timeout
    @timeout ||= 10
  end

  def self.timeout=(val)
    @timeout = val
  end

  def self.connect_timeout
    @connect_timeout ||= 10
  end

  def self.connect_timeout=(val)
    @connect_timeout = val
  end

  def self.user_agent
    @user_agent ||= "MarketBot/#{MarketBot::VERSION} / " \
      '(+https://github.com/chadrem/market_bot)'
  end

  def self.user_agent=(val)
    @user_agent = val
  end
end
