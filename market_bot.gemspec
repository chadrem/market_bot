
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'market_bot/version'

Gem::Specification.new do |gem|
  gem.name          = 'market_bot'
  gem.version       = MarketBot::VERSION
  gem.authors       = ['Chad Remesch']
  gem.email         = ['chad@remesch.com']
  gem.description   = "Market Bot is a high performance Ruby scraper for Google's Android Market with a simple to use API.  It is built on top of Nokogiri and Typhoeus."
  gem.summary       = "Market Bot: High performance Ruby scraper for Google's Android Market"
  gem.homepage      = 'https://github.com/chadrem/market_bot'
  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('nokogiri', '>= 0')
  gem.add_dependency('typhoeus', '>= 1.0.2')

  gem.add_development_dependency('bundler', '> 1.7')
  gem.add_development_dependency('rake', '> 10.0')
  gem.add_development_dependency('rspec', '~> 3.6')
  gem.add_development_dependency('rubocop', '> 0.53.0')
  # gem.add_development_dependency('guard', '~> 2.13')
  # gem.add_development_dependency('guard-rspec', '~> 4.6')
  # gem.add_development_dependency('byebug', '>= 8.2')
end
