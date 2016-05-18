module MarketBot
  class Util
    def self.fix_content_url(url)
      url =~ /\A\/\// ? "https:#{url}" : url
    end

    def self.build_request_opts(opts)
      opts ||= {}
      opts[:timeout] ||= MarketBot.timeout
      opts[:connecttimeout] ||= MarketBot.connect_timeout
      opts[:headers] ||= {}
      opts[:headers]['User-Agent'] ||= MarketBot.user_agent

      opts
    end
  end
end
