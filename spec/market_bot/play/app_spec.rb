require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

data = [
  {
    package: 'com.bluefroggaming.popdat',
    html: read_file(File.dirname(__FILE__), 'data', 'app-com.bluefroggaming.popdat.txt'),
  },
  {
    package: 'com.mg.android',
    html:  read_file(File.dirname(__FILE__), 'data', 'app-com.mg.android.txt')
  },
]

describe MarketBot::Play::App do
  it 'should construct' do
    app = App.new(data[0][:package])
    expect(app.package).to eq(data[0][:package])
  end

  it 'should generate URLs' do
    expect(App.new(data[0][:package]).store_url).to eq("https://play.google.com/store/apps/details?id=#{data[0][:package]}&hl=en")
  end

  it 'should populate the attribute getters' do
    app = App.new(data[0][:package])
    response = Typhoeus::Response.new(:code => 200, :headers => '', :body => data[0][:html])
    Typhoeus.stub(app.store_url).and_return(response)
    app.update
  end

  it 'should raise a ResponseError on a 404' do
    app = App.new(data[0][:package])
    response = Typhoeus::Response.new(:code => 404)
    Typhoeus.stub(app.store_url).and_return(response)

    expect {
      app.update
    }.to raise_error(MarketBot::ResponseError)
  end

  context 'parsing' do
    it 'should populate a hash with the correct keys/values' do
    end
  end
end
