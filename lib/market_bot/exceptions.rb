module MarketBot
  class MarketBotError < StandardError; end
  class ResponseError < MarketBotError; end
  class NotFoundError < ResponseError; end
  class UnavailableError < ResponseError; end
end
