module MarketBot
  class Util
    def self.fix_content_url(url)
      url =~ /\A\/\// ? "https:#{url}" : url
    end
  end
end
