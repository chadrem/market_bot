$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'

begin
  require 'debugger'
rescue Exception => e
end

require 'simplecov'
SimpleCov.start

require 'market_bot'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Typhoeus::Hydra.allow_net_connect = false

RSpec.configure do |config|

end

def read_file(*path)
  data = nil
  File.open(File.join(path), 'r') { |f| data = f.read }
  return data
end
