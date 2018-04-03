require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'MarketBot' do
  it 'should support changing the default request timeout' do
    MarketBot.timeout = 5
    expect(MarketBot.timeout).to eq(5)
  end

  it 'should support changing the default request connect timeout' do
    MarketBot.connect_timeout = 5
    expect(MarketBot.connect_timeout).to eq(5)
  end

  it 'should support changing the default request user agent' do
    MarketBot.user_agent = 'My Custom Bot'
    expect(MarketBot.user_agent).to eq('My Custom Bot')
  end
end
