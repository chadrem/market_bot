require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = 'com.bluefroggaming.popdat'
test_src_data = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
test_src_data2 = read_file(File.dirname(__FILE__), 'data', 'app_2.txt')
test_src_data3 = read_file(File.dirname(__FILE__), 'data', 'app_3.txt')

def check_getters(app)
  it 'should populate the getters' do
    app.title.should == 'Pop Dat'
    app.rating.should == '4.6'
    app.updated.should == 'August 26, 2011'
    app.current_version.should == '1.0'
    app.requires_android.should == '2.2 and up'
    app.category.should == 'Arcade & Action'
    app.category_url.should == 'ARCADE'
    app.installs.should == '500 - 1,000'
    app.size.should == '9.0M'
    app.price.should == 'Free'
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^<div.*?>An action-packed blend of split-second skill and luck-based gameplay!/
    app.votes.should == '7'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.users_also_installed.should == [{:app_id=>"com.hdl.datbom"}, {:app_id=>"tan.game.bom"}, {:app_id=>"com.worms2armageddon.app"}, {:app_id=>"dk.sparx.attackwave"}, {:app_id=>"com.luminencelabs.ProjectY"}, {:app_id=>"com.inspiredandroid.orcgenocide"}]
    app.related.should == [{:app_id=>"com.hdl.datbom"}, {:app_id=>"tan.game.bom"}, {:app_id=>"com.worms2armageddon.app"}, {:app_id=>"dk.sparx.attackwave"}, {:app_id=>"com.luminencelabs.ProjectY"}, {:app_id=>"com.inspiredandroid.orcgenocide"}]
    app.banner_icon_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.banner_image_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.website_url.should == 'http://bluefroggaming.com'
    app.email.should == 'support@hdgames.zendesk.com'
    app.youtube_video_ids.should == []
    app.screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
    app.whats_new.should == nil
    #app.permissions.should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
    # Stubbing out for now, can't find them in the redesigned page.
    app.permissions.should == []

    app.rating_distribution.should == {5=>6, 4=>0, 3=>0, 2=>1, 1=>0}
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
      result = App.parse(test_src_data)

      result[:title].should == 'Pop Dat'
      result[:rating].should == '4.6'
      result[:updated].should == 'August 26, 2011'
      result[:current_version].should == '1.0'
      result[:requires_android].should == '2.2 and up'
      result[:category].should == 'Arcade & Action'
      result[:category_url].should == 'ARCADE'
      result[:installs].should == '500 - 1,000'
      result[:size].should == '9.0M'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /An action-packed blend of split-second/
      result[:votes].should == '7'
      result[:developer].should == 'Blue Frog Gaming'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
      result[:website_url].should == 'http://bluefroggaming.com'
      result[:email].should == 'support@hdgames.zendesk.com'
      result[:youtube_video_ids].should == []
      result[:screenshot_urls].should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
      result[:whats_new].should == nil
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>6, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote'
      result[:rating].should == '4.7'
      result[:updated].should == 'November 26, 2013'
      result[:current_version].should == 'Varies with device'
      result[:requires_android].should == 'Varies with device'
      result[:category].should == 'Productivity'
      result[:category_url].should == 'PRODUCTIVITY'
      result[:size].should == 'Varies with device'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /New York Times/
      result[:votes].should == '715721'
      result[:developer].should == 'Evernote Corporation'
      result[:installs].should == '10,000,000 - 50,000,000'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/si0cgkp2rkVX5JhhBYrtZ4cy2I1hZcrx8aiz-v8MjvPykfhT7-YAM2B8MNi0OCF9AQ=w300'
      result[:banner_image_url].should == 'https://lh3.ggpht.com/si0cgkp2rkVX5JhhBYrtZ4cy2I1hZcrx8aiz-v8MjvPykfhT7-YAM2B8MNi0OCF9AQ=w300'
      result[:website_url].should == 'http://evernote.com/privacy/'
      result[:email].should == nil
      result[:youtube_video_ids].should == ['Ag_IGEgAa9M']
      result[:screenshot_urls].should == ["https://lh3.ggpht.com/54lY5NF-Af-oOCyW2JYhysfcFHiaXEgD6vj4PaaMMN9qopDKtgxD5R1Pufp7HErUBw=h310", "https://lh6.ggpht.com/3LaP-qhEuGxf0HnPAqnRDbXZ-ML6gfGmiZCTIAh74U3LnEJTXzCSjc6qEBfRPrRdXKJL=h310", "https://lh3.ggpht.com/YayoH5bQhg1Podr15Uv68daoM2u0v41VNF9LHVDNQ9cyPjUDBcO8byQ-m3jLfXOOdPY=h310", "https://lh5.ggpht.com/_nFgawWYq1g7Ohx88pv5zJCRNVjbw03sS7xgnodYPoyu-dQUTkre1X_kNJuQCdMG7wTt=h310", "https://lh3.ggpht.com/lbH6Civ5KKuuMPNVvJ6zbLvNJD0OZl_MTq_aNiyDunqg2vYr5BsHI96FyRzS1SJ8bLc=h310", "https://lh5.ggpht.com/lPMXIRwq4MI1RsWYP5zfTdRwM2czXpK6NhmCo05T0XSyHD9CYin9HEqzJRNp7jKseY0=h310", "https://lh6.ggpht.com/kZxxpoIKYJPzWH68XOIILL4ZfkhTcCxWJGLf8WtyM9IvCI5uTlWID2F1PU40QNyf20d6=h310", "https://lh6.ggpht.com/hLSn7upa4-jFePZdZtjte2akPt4E5bTFZ4FvHKkzQkMb1YpFNx0GJw8riT6MtEJYwFA=h310", "https://lh3.ggpht.com/Rr2BJz6271odPQQ1Ga4sKNhPheL1Uj085C6BVlk-HwO7FzM0xC_3FpY1eSdAjsQLtQ=h310", "https://lh5.ggpht.com/UJdh5Ozb7HuiG3PLl1hkpnFzWL_knn48BGfolQq9caPuycT21YJAXmKf_93Vsa3w2ZY=h310"]
      result[:whats_new].should =~ /What's New/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Hardware controls", :description=>"record audio", :description_full=>"Allows the app to access the audio record path."}, {:security=>"dangerous", :group=>"Hardware controls", :description=>"take pictures and videos", :description_full=>"Allows the app to take pictures and videos with the camera. This allows the app at any time to collect images the camera is seeing."}, {:security=>"dangerous", :group=>"Your location", :description=>"coarse (network-based) location", :description_full=>"Access coarse location sources such as the cellular network database to determine an approximate tablet location, where available. Malicious apps may use this to determine approximately where you are. Access coarse location sources such as the cellular network database to determine an approximate phone location, where available. Malicious apps may use this to determine approximately where you are."}, {:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read contact data", :description_full=>"Allows the app to read all of the contact (address) data stored on your tablet. Malicious apps may use this to send your data to other people. Allows the app to read all of the contact (address) data stored on your phone. Malicious apps may use this to send your data to other people."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read sensitive log data", :description_full=>"Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the tablet, potentially including personal or private information. Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the phone, potentially including personal or private information."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read calendar events plus confidential information", :description_full=>"Allows the app to read all calendar events stored on your tablet, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge. Allows the app to read all calendar events stored on your phone, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"dangerous", :group=>"Storage", :description=>"modify/delete USB storage contents modify/delete SD card contents", :description_full=>"Allows the app to write to the USB storage. Allows the app to write to the SD card."}, {:security=>"dangerous", :group=>"System tools", :description=>"prevent tablet from sleeping prevent phone from sleeping", :description_full=>"Allows the app to prevent the tablet from going to sleep. Allows the app to prevent the phone from going to sleep."}, {:security=>"safe", :group=>"Your accounts", :description=>"discover known accounts", :description_full=>"Allows the app to get the list of accounts known by the tablet. Allows the app to get the list of accounts known by the phone."}, {:security=>"safe", :group=>"Hardware controls", :description=>"control vibrator", :description_full=>"Allows the app to control the vibrator."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}, {:security=>"safe", :group=>"Network communication", :description=>"view Wi-Fi state", :description_full=>"Allows the app to view the information about the state of Wi-Fi."}, {:security=>"safe", :group=>"Default", :description=>"Market billing service", :description_full=>"Allows the user to purchase items through Market from within this application"}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>542614, 4=>143296, 3=>17909, 2=>4171, 1=>7731}
      result[:html].should == test_src_data2
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data3)

      result[:title].should == 'WeatherPro'
      result[:updated].should == 'November 11, 2013'
      result[:current_version].should == '3.0.2'
      result[:requires_android].should == '2.1 and up'
      result[:category].should == 'Weather'
      result[:category_url].should == 'WEATHER'
      result[:size].should == '7.6M'
      result[:price].should == '$2.99'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^<div.*?>WeatherPro for Android features high-quality seven-day forecasts/
      result[:developer].should == 'MeteoGroup'
      result[:rating].should == "4.4"
      result[:votes].should == "20167"
      result[:banner_icon_url].should == 'https://lh4.ggpht.com/kYFmcFWBWg_XfhKTk7WaXk9y4JNO2mIe3TkT6MqR-mjoiNgy8zj-EZY6ADjJBKKA=w300'
      result[:banner_image_url].should == 'https://lh4.ggpht.com/kYFmcFWBWg_XfhKTk7WaXk9y4JNO2mIe3TkT6MqR-mjoiNgy8zj-EZY6ADjJBKKA=w300'
      result[:website_url].should == 'http://www.weatherpro.eu/privacy-policy.html'
      result[:email].should == 'support@android.weatherpro.de'
      result[:youtube_video_ids].should == []
      result[:whats_new].should =~ /WeatherPro 3.0 for Android brings with it/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>12407, 4=>5360, 3=>1069, 2=>437, 1=>894}
      result[:html].should == test_src_data3
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      result[:related].should be_a(Array)
      result[:users_also_installed].should be_a(Array)
      result[:more_from_developer].should be_a(Array)

      result[:related].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:users_also_installed].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:more_from_developer].first[:app_id].should == 'com.evernote.skitch'
    end
  end

  context 'Updating' do
    context 'Quick API' do
      app = App.new(test_id)

      response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_data)
      Typhoeus.stub(app.market_url).and_return(response)

      app.update
      check_getters(app)
    end

    context 'Batch API' do
      hydra = Typhoeus::Hydra.new
      app = App.new(test_id, :hydra => hydra)

      response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_data)
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
