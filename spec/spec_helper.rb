require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'

begin
  require 'byebug'
rescue Exception => e
end

begin
  require 'simplecov'
  SimpleCov.start
rescue Exception => e
end

require 'market_bot'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end

Typhoeus.configure do |config|
  config.block_connection = true
end

def read_file(*path)
  data = nil
  File.open(File.join(path), 'r') { |f| data = f.read }
  return data
end
