# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'market_bot/version'

Gem::Specification.new do |gem|
  gem.name          = 'market_bot'
  gem.version       = MarketBot::VERSION
  gem.authors       = ['Chad Remesch']
  gem.email         = ['chad@remesch.com']
  gem.description   = %q{Market Bot is a high performance Ruby scraper for Google's Android Market with a simple to use API.  It is built on top of Nokogiri and Typhoeus.}
  gem.summary       = %q{Market Bot: High performance Ruby scraper for Google's Android Market}
  gem.homepage      = 'https://github.com/chadrem/market_bot'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('typhoeus', '>= 0.6.0')
  gem.add_dependency('nokogiri', '>= 0')

  gem.add_development_dependency('rspec', '= 2.8.0')
end
