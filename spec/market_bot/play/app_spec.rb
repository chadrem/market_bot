require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

test_id = 'com.bluefroggaming.popdat'
test_src_data1 = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
test_src_data2 = read_file(File.dirname(__FILE__), 'data', 'app_2.txt')
test_src_data3 = read_file(File.dirname(__FILE__), 'data', 'app_3.txt')

def check_getters(app)
  it 'should populate the getters' do
    expect(app.title).to eq('Pop Dat')
    expect(app.rating).to eq('4.7')
    expect(app.updated).to eq('August 26, 2011')
    expect(app.current_version).to eq('1.0')
    expect(app.requires_android).to eq('2.2 and up')
    expect(app.category).to eq('Arcade')
    expect(app.category_url).to eq('GAME_ARCADE')
    expect(app.installs).to eq('500 - 1,000')
    expect(app.size).to eq('9.0M')
    expect(app.price).to eq('0')
    expect(app.content_rating).to eq('Unrated')
    expect(app.description).to match(/^<div.*?>An action-packed blend of split-second skill and luck-based gameplay!/)
    expect(app.votes).to eq('11')
    expect(app.more_from_developer).to eq([{:app_id=>"com.bluefroggaming.ghost_chicken"}])
    expect(app.similar).to eq([{:app_id=>"si.custom.snake"}])
    expect(app.banner_icon_url).to eq('https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300')
    expect(app.banner_image_url).to eq('https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300')
    expect(app.website_url).to eq('http://bluefroggaming.com')
    expect(app.email).to eq('support@hdgames.zendesk.com')
    expect(app.screenshot_urls.first).to eq("https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310")
    expect(app.full_screenshot_urls.first).to eq("https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900")
    expect(app.whats_new).to eq(nil)
    expect(app.rating_distribution).to eq({5=>10, 4=>0, 3=>0, 2=>1, 1=>0})
    expect(app.html.class).to eq(String)
  end
end

describe 'App' do
  context 'Construction' do
    it 'should copy the app_id param' do
      app = App.new(test_id)
      expect(app.app_id).to eq(test_id)
    end

    it 'should copy optional params' do
      hydra = Typhoeus::Hydra.new
      app = App.new(test_id, :hydra => hydra)
      expect(app.hydra).to equal(hydra)
    end
  end

  it 'should generate market URLs' do
    expect(App.new(test_id).market_url).to eq("https://play.google.com/store/apps/details?id=#{test_id}&hl=en")
  end

  context 'Parsing' do
    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data1)

      expect(result[:title]).to eq('Pop Dat')
      expect(result[:rating]).to eq('4.7')
      expect(result[:updated]).to eq('August 26, 2011')
      expect(result[:current_version]).to eq('1.0')
      expect(result[:requires_android]).to eq('2.2 and up')
      expect(result[:category]).to eq('Arcade')
      expect(result[:category_url]).to eq('GAME_ARCADE')
      expect(result[:installs]).to eq('500 - 1,000')
      expect(result[:size]).to eq('9.0M')
      expect(result[:price]).to eq('0')
      expect(result[:content_rating]).to eq('Unrated')
      expect(result[:description]).to match(/An action-packed blend of split-second/)
      expect(result[:votes]).to eq('11')
      expect(result[:developer]).to eq('Blue Frog Gaming')
      expect(result[:banner_icon_url]).to eq('https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300')
      expect(result[:website_url]).to eq('http://bluefroggaming.com')
      expect(result[:email]).to eq('support@hdgames.zendesk.com')
      expect(result[:screenshot_urls].first).to eq("https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310")
      expect(result[:full_screenshot_urls].first).to eq("https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900")
      expect(result[:whats_new]).to eq(nil)
      expect(result[:rating_distribution]).to eq({5=>10, 4=>0, 3=>0, 2=>1, 1=>0})
      expect(result[:html]).to eq(test_src_data1)

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      expect(result[:title]).to eq('Evernote - stay organized.')
      expect(result[:rating]).to eq('4.6')
      expect(result[:updated]).to eq('May 5, 2016')
      expect(result[:current_version]).to eq('Varies with device')
      expect(result[:requires_android]).to eq('Varies with device')
      expect(result[:category]).to eq('Productivity')
      expect(result[:category_url]).to eq('PRODUCTIVITY')
      expect(result[:size]).to eq('Varies with device')
      expect(result[:price]).to eq('0')
      expect(result[:content_rating]).to eq('Everyone')
      expect(result[:description]).to match(/New York Times/)
      expect(result[:votes]).to eq('1390801')
      expect(result[:developer]).to eq('Evernote Corporation')
      expect(result[:installs]).to eq("100,000,000 - 500,000,000")
      expect(result[:banner_icon_url]).to eq('https://lh3.googleusercontent.com/atqaMgabx_ZXVi4AJUcDiHTy-G3nwMAGsjoCsfpebwPjXMV_QXTPefko7Wbwen-EnUo=w300')
      expect(result[:banner_image_url]).to eq('https://lh3.googleusercontent.com/atqaMgabx_ZXVi4AJUcDiHTy-G3nwMAGsjoCsfpebwPjXMV_QXTPefko7Wbwen-EnUo=w300')
      expect(result[:website_url]).to eq('http://evernote.com/privacy/')
      expect(result[:email]).to eq('appstore-evernote-android@evernote.com')
      expect(result[:screenshot_urls].first).to eq("https://lh3.googleusercontent.com/AkEKnkvCyM6e-FS5RT5DExb56uCUDc1S0cc3sI4IORrJAT-HTLQz-jPu8whw-BL5oA=h310")
      expect(result[:full_screenshot_urls].first).to eq("https://lh3.googleusercontent.com/AkEKnkvCyM6e-FS5RT5DExb56uCUDc1S0cc3sI4IORrJAT-HTLQz-jPu8whw-BL5oA=h900")
      expect(result[:whats_new]).to match(/What's New/)
      expect(result[:rating_distribution]).to eq({5=>1009112, 4=>280079, 3=>51367, 2=>17062, 1=>32966})
      expect(result[:html]).to eq(test_src_data2)
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data3)

      expect(result[:title]).to eq('WeatherPro')
      expect(result[:updated]).to eq("March 4, 2016")
      expect(result[:current_version]).to eq("4.5.1")
      expect(result[:requires_android]).to eq('2.3 and up')
      expect(result[:category]).to eq('Weather')
      expect(result[:category_url]).to eq('WEATHER')
      expect(result[:size]).to eq('11M')
      expect(result[:price]).to eq('$2.99')
      expect(result[:content_rating]).to eq('Everyone')
      expect(result[:description]).to match(/^.*WeatherPro has been created by MeteoGroup,/)
      expect(result[:developer]).to eq('MeteoGroup')
      expect(result[:rating]).to eq('4.3')
      expect(result[:votes]).to eq('44121')
      expect(result[:banner_icon_url]).to eq('https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300')
      expect(result[:banner_image_url]).to eq('https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300')
      expect(result[:website_url]).to eq('http://www.meteogroup.com/en/gb/about-meteogroup/privacy-policy-and-cookies.html')
      expect(result[:email]).to eq('support@android.weatherpro.de')
      expect(result[:whats_new]).to match(/We have fixed bugs which can be reported via our help center/)
      expect(result[:rating_distribution]).to eq({5=>26367, 4=>11216, 3=>2613, 2=>1455, 1=>2460})
      expect(result[:html]).to eq(test_src_data3)
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      expect(result[:similar]).to be_a(Array)
      expect(result[:more_from_developer]).to be_a(Array)

      expect(result[:similar].first[:app_id]).to eq('com.socialnmobile.dictapps.notepad.color.note')
      expect(result[:more_from_developer].first[:app_id]).to eq('com.evernote.wear')
    end

    it 'should populate the reviews' do
      result = App.parse(test_src_data3)
      expect(result[:reviews]).to be_a(Array)
      result[:reviews].size == 9
      expect(result[:reviews][2][:author_name]).to eq('Mark Kell')
      expect(result[:reviews][2][:review_title]).to  eq('It is the best... But not for an S7 Edge')
      expect(result[:reviews][2][:review_text]).to  match(/developers of this app had a good understanding of Android for the S6 Edge/)
      expect(result[:reviews][2][:review_score]).to  eq(2)
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
        expect(callback_flag).to be(true)
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
        expect(callback_flag).to be(true)
      end

      it 'should set error to the exception' do
        expect(error).to be_a(Exception)
      end
    end
  end
end
