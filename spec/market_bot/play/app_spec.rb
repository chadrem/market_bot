require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

test_id = 'com.bluefroggaming.popdat'
test_src_data1 = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
test_src_data2 = read_file(File.dirname(__FILE__), 'data', 'app_2.txt')
test_src_data3 = read_file(File.dirname(__FILE__), 'data', 'app_3.txt')

def check_getters(app)
  it 'should populate the getters' do
    app.title.should == 'Pop Dat'
    app.rating.should == '4.7'
    app.updated.should == 'August 26, 2011'
    app.current_version.should == '1.0'
    app.requires_android.should == '2.2 and up'
    app.category.should == 'Arcade'
    app.category_url.should == 'GAME_ARCADE'
    app.installs.should == '500 - 1,000'
    app.size.should == '9.0M'
    app.price.should == '0'
    app.content_rating.should == 'Unrated'
    app.description.should =~ /^<div.*?>An action-packed blend of split-second skill and luck-based gameplay!/
    app.votes.should == '11'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.similar.should == [{:app_id=>"si.custom.snake"}]
    app.banner_icon_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.banner_image_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.website_url.should == 'http://bluefroggaming.com'
    app.email.should == 'support@hdgames.zendesk.com'
    app.screenshot_urls.first.should == "https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310"
    app.full_screenshot_urls.first.should == "https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900"
    app.whats_new.should == nil
    app.rating_distribution.should == {5=>10, 4=>0, 3=>0, 2=>1, 1=>0}
    app.html.class.should == String
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
    App.new(test_id).market_url.should == "https://play.google.com/store/apps/details?id=#{test_id}&hl=en"
  end

  context 'Parsing' do
    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data1)

      result[:title].should == 'Pop Dat'
      result[:rating].should == '4.7'
      result[:updated].should == 'August 26, 2011'
      result[:current_version].should == '1.0'
      result[:requires_android].should == '2.2 and up'
      result[:category].should == 'Arcade'
      result[:category_url].should == 'GAME_ARCADE'
      result[:installs].should == '500 - 1,000'
      result[:size].should == '9.0M'
      result[:price].should == '0'
      result[:content_rating].should == 'Unrated'
      result[:description].should =~ /An action-packed blend of split-second/
      result[:votes].should == '11'
      result[:developer].should == 'Blue Frog Gaming'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
      result[:website_url].should == 'http://bluefroggaming.com'
      result[:email].should == 'support@hdgames.zendesk.com'
      result[:screenshot_urls].first.should == "https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310"
      result[:full_screenshot_urls].first.should == "https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900"
      result[:whats_new].should == nil
      result[:rating_distribution].should == {5=>10, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data1

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote - stay organized.'
      result[:rating].should == '4.6'
      result[:updated].should == 'May 5, 2016'
      result[:current_version].should == 'Varies with device'
      result[:requires_android].should == 'Varies with device'
      result[:category].should == 'Productivity'
      result[:category_url].should == 'PRODUCTIVITY'
      result[:size].should == 'Varies with device'
      result[:price].should == '0'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /New York Times/
      result[:votes].should == '1390801'
      result[:developer].should == 'Evernote Corporation'
      result[:installs].should == "100,000,000 - 500,000,000"
      result[:banner_icon_url].should == 'https://lh3.googleusercontent.com/atqaMgabx_ZXVi4AJUcDiHTy-G3nwMAGsjoCsfpebwPjXMV_QXTPefko7Wbwen-EnUo=w300'
      result[:banner_image_url].should == 'https://lh3.googleusercontent.com/atqaMgabx_ZXVi4AJUcDiHTy-G3nwMAGsjoCsfpebwPjXMV_QXTPefko7Wbwen-EnUo=w300'
      result[:website_url].should == 'http://evernote.com/privacy/'
      result[:email].should == 'appstore-evernote-android@evernote.com'
      result[:screenshot_urls].first.should == "https://lh3.googleusercontent.com/AkEKnkvCyM6e-FS5RT5DExb56uCUDc1S0cc3sI4IORrJAT-HTLQz-jPu8whw-BL5oA=h310"
      result[:full_screenshot_urls].first.should == "https://lh3.googleusercontent.com/AkEKnkvCyM6e-FS5RT5DExb56uCUDc1S0cc3sI4IORrJAT-HTLQz-jPu8whw-BL5oA=h900"
      result[:whats_new].should =~ /What's New/
      result[:rating_distribution].should == {5=>1009112, 4=>280079, 3=>51367, 2=>17062, 1=>32966}
      result[:html].should == test_src_data2
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data3)

      result[:title].should == 'WeatherPro'
      result[:updated].should == "March 4, 2016"
      result[:current_version].should == "4.5.1"
      result[:requires_android].should == '2.3 and up'
      result[:category].should == 'Weather'
      result[:category_url].should == 'WEATHER'
      result[:size].should == '11M'
      result[:price].should == '$2.99'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /^.*WeatherPro has been created by MeteoGroup,/
      result[:developer].should == 'MeteoGroup'
      result[:rating].should == '4.3'
      result[:votes].should == '44121'
      result[:banner_icon_url].should == 'https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300'
      result[:banner_image_url].should == 'https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300'
      result[:website_url].should == 'http://www.meteogroup.com/en/gb/about-meteogroup/privacy-policy-and-cookies.html'
      result[:email].should == 'support@android.weatherpro.de'
      result[:whats_new].should =~ /We have fixed bugs which can be reported via our help center/
      result[:rating_distribution].should == {5=>26367, 4=>11216, 3=>2613, 2=>1455, 1=>2460}
      result[:html].should == test_src_data3
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      result[:similar].should be_a(Array)
      result[:more_from_developer].should be_a(Array)

      result[:similar].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:more_from_developer].first[:app_id].should == 'com.evernote.wear'
    end

    it 'should populate the reviews' do
      result = App.parse(test_src_data3)
      result[:reviews].should be_a(Array)
      result[:reviews].size == 9
      result[:reviews][2][:author_name].should == 'Mark Kell'
      result[:reviews][2][:review_title].should  == 'It is the best... But not for an S7 Edge'
      result[:reviews][2][:review_text].should  =~ /developers of this app had a good understanding of Android for the S6 Edge/
      result[:reviews][2][:review_score].should  == 2
    end

  end

  context 'Updating' do
    context 'Quick API' do
      app = App.new(test_id)

      response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_data1)
      Typhoeus.stub(app.market_url).and_return(response)

      app.update
      check_getters(app)
    end

    context "Quick API not found" do
      let(:app) { App.new(test_id) }

      before do
        response = Typhoeus::Response.new(:code => 404)
        Typhoeus.stub(app.market_url).and_return(response)
      end

      it "raises a ResponseError" do
        expect {
          app.update
        }.to raise_error(MarketBot::ResponseError)
      end
    end

    context 'Batch API' do
      hydra = Typhoeus::Hydra.new
      app = App.new(test_id, :hydra => hydra)

      response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_data1)
      Typhoeus.stub(app.market_url).and_return(response)

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
      Typhoeus.stub(app.market_url).and_return(response)

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
