module MarketBot
  class MarketBotError < StandardError; end
  class ResponseError < MarketBotError; end
  class AppNotFoundError < ResponseError; end
end
