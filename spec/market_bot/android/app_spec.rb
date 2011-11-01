require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = 'com.bluefroggaming.popdat'
test_src_data = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
test_src_data2 = read_file(File.dirname(__FILE__), 'data', 'app_2.txt')
test_src_data3 = read_file(File.dirname(__FILE__), 'data', 'app_3.txt')

def check_getters(app)
  it 'should populate the getters' do
    app.title.should == 'Pop Dat'
    app.rating.should == '4.2'
    app.updated.should == 'August 27, 2011'
    app.current_version.should == '1.0'
    app.requires_android.should == '2.2 and up'
    app.category.should == 'Arcade & Action'
    app.installs.should == '50 - 100'
    app.size.should == '9.0M'
    app.price.should == 'Free'
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^Experience the next level of chain/
    app.votes.should == '4'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.users_also_installed.should == [{:app_id=>"com.cyancanyon.blasted_lite"}, {:app_id=>"com.hackathon.androidandretta"}, {:app_id=>"com.slothenvy.hexadromefree"}, {:app_id=>"com.moongames.southsurfers112"}]
    app.related.should == []
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
      result[:rating].should == '4.2'
      result[:updated].should == 'August 27, 2011'
      result[:current_version].should == '1.0'
      result[:requires_android].should == '2.2 and up'
      result[:category].should == 'Arcade & Action'
      result[:installs].should == '50 - 100'
      result[:size].should == '9.0M'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /^Experience the next level of chain/
      result[:votes].should == '4'
      result[:developer].should == 'Blue Frog Gaming'

      result
    end

    it 'should populate a hash with the correct keys/values even when the installs field is missing' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote'
      result[:rating].should == '4.6'
      result[:updated].should == 'October 13, 2011'
      result[:current_version].should == '3.2.2'
      result[:requires_android].should == '1.6 and up'
      result[:category].should == 'Productivity'
      result[:size].should == '5.0M'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^Evernote turns your Android device into an extension/
      result[:votes].should == '173,307'
      result[:developer].should == 'Evernote Corp.'
      result[:installs].should == nil
    end

    it 'should populate a hash with the correct keys/values even when rating and votes are missing' do
      result = App.parse(test_src_data3)

      result[:title].should == 'Thermometer HD'
      result[:updated].should == 'July 2, 2011'
      result[:current_version].should == '1.5.1'
      result[:requires_android].should == '2.0 and up'
      result[:category].should == 'Weather'
      result[:size].should == '98k'
      result[:price].should == '$0.99'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^Want to know the up-to-date temperature and other weather/
      result[:developer].should == 'Kooistar Solutions'
      result[:rating].should == nil
      result[:votes].should == nil
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      result[:related].should be_a(Array)
      result[:users_also_installed].should be_a(Array)
      result[:more_from_developer].should be_a(Array)

      result[:related].first[:app_id].should == 'com.intsig.camscanner'
      result[:users_also_installed].first[:app_id].should == 'com.divnil.paintforevernote'
      result[:more_from_developer].first[:app_id].should == 'com.evernote.skitch'
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

      callback_flag = false

      app.enqueue_update do |a|
        callback_flag = true
      end

      hydra.run

      it 'should call the callback' do
        callback_flag.should be(true)
      end

      check_getters(app)
    end

    context 'Batch API parser error' do
      hydra = Typhoeus::Hydra.new
      app = App.new(test_id, :hydra => hydra)
      response = Typhoeus::Response.new(:code => 200, :headers => '', :body => 'some broken app page')
      hydra.stub(:get, app.market_url).and_return(response)

      callback_flag = false
      error = nil

      app.enqueue_update do |a|
        callback_flag = true
        error = a.error
      end

      hydra.run

      it 'should call the callback' do
        callback_flag.should be(true)
      end

      it 'should set error to the exception' do
        error.should be_a(Exception)
      end
    end
  end
end
