require 'uri'

require 'typhoeus'
require 'nokogiri'

require 'market_bot/version'
require 'market_bot/exceptions'
require 'market_bot/util'
require 'market_bot/play/app/constants'
require 'market_bot/play/app'
require 'market_bot/play/chart/constants'
require 'market_bot/play/chart'
require 'market_bot/play/developer'

module MarketBot
  def self.hydra
    @hydra ||= Typhoeus::Hydra.new(:max_concurrency => 5)
  end

  def self.timeout
    @timeout ||= 10
  end

  def self.timeout=(val)
    @timeout = val
  end

  def self.connecttimeout
    @connecttimeout ||= 10
  end

  def self.connecttimeout=(val)
    @connecttimeout = val
  end
end

