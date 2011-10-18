require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = 'com.bluefroggaming.popdat'
test_src_data = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')

def check_getters(app)
  it 'should populate the getters' do
    app.title.should == 'Pop Dat'
    app.rating.should == '4'
    app.updated.should == 'August 27, 2011'
    app.current_version.should == '1.0'
    app.requires_android.should == '2.2 and up'
    app.category.should == 'Arcade & Action'
    app.installs.should == '50 - 100'
    app.size.should == '18M'
    app.price.should == 'Free'
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^Experience the next level of chain/
  end
end

describe 'App' do
  context 'Construction' do
    it 'should copy the app_id param' do
      app = App.new(test_id)
      app.app_id.should == test_id
    end

    it 'should copy optional params' do
      hydra = Typhoeus::Hydra.new
      app = App.new(test_id, :hydra => hydra)
      app.hydra.should equal(hydra)
    end
  end

  it 'should generate market URLs' do
   App.new(test_id).market_url.should == "https://market.android.com/details?id=#{test_id}"
  end

  context 'Parsing' do
    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data)

      result[:title].should == 'Pop Dat'
      result[:rating].should == '4'
      result[:updated].should == 'August 27, 2011'
      result[:current_version].should == '1.0'
      result[:requires_android].should == '2.2 and up'
      result[:category].should == 'Arcade & Action'
      result[:installs].should == '50 - 100'
      result[:size].should == '18M'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /^Experience the next level of chain/
      result[:votes].should == '4'

      result
    end
  end

  context 'Updating' do
    response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_data)

    context 'Quick API' do
      app = App.new(test_id)
      hydra = Typhoeus::Hydra.hydra
      hydra.stub(:get, app.market_url).and_return(response)

      app.update
      check_getters(app)
    end

    context 'Batch API' do
      hydra = Typhoeus::Hydra.new
      app = App.new(test_id, :hydra => hydra)
      hydra.stub(:get, app.market_url).and_return(response)

      app.enqueue_update
      hydra.run
      check_getters(app)
    end
  end
end
