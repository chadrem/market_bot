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
    app.installs.should == '500 - 1,000'
    app.size.should == '9.0M'
    app.price.should == 'Free'
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^<div>An action-packed blend of split-second skill and luck-based gameplay!/
    app.votes.should == '7'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.users_also_installed.should == [{:app_id=>"com.coldbeamgames.beathazardultragooglefull"}, {:app_id=>"net.hexage.radiant.hd"}, {:app_id=>"net.hexage.radiant"}, {:app_id=>"com.androkera.brokenscreen"}, {:app_id=>"com.ninjakiwi.bloonstd5"}, {:app_id=>"com.lsgvgames.slideandflyfull"}, {:app_id=>"com.metamoki.Aquapop"}, {:app_id=>"org.lukeallen.bomberfull"}, {:app_id=>"com.fungamesforfree.snipershooter.free"}, {:app_id=>"com.rubicon.dev.glwg"}, {:app_id=>"net.hexage.defense"}, {:app_id=>"com.rubicon.dev.gbwg"}, {:app_id=>"com.ArtInGames.AirAttackHDPart2"}, {:app_id=>"net.hexage.radiant.lite"}, {:app_id=>"com.ecogame.eggshoot"}, {:app_id=>"com.yoyogames.droidtntbf"}]
    app.related.should == [{:app_id=>"com.coldbeamgames.beathazardultragooglefull"}, {:app_id=>"net.hexage.radiant.hd"}, {:app_id=>"net.hexage.radiant"}, {:app_id=>"com.androkera.brokenscreen"}, {:app_id=>"com.ninjakiwi.bloonstd5"}, {:app_id=>"com.lsgvgames.slideandflyfull"}, {:app_id=>"com.metamoki.Aquapop"}, {:app_id=>"org.lukeallen.bomberfull"}, {:app_id=>"com.fungamesforfree.snipershooter.free"}, {:app_id=>"com.rubicon.dev.glwg"}, {:app_id=>"net.hexage.defense"}, {:app_id=>"com.rubicon.dev.gbwg"}, {:app_id=>"com.ArtInGames.AirAttackHDPart2"}, {:app_id=>"net.hexage.radiant.lite"}, {:app_id=>"com.ecogame.eggshoot"}, {:app_id=>"com.yoyogames.droidtntbf"}]
    app.banner_icon_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.banner_image_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.website_url.should == 'http://bluefroggaming.com'
    app.email.should == 'support@hdgames.zendesk.com'
    app.youtube_video_ids.should == []
    app.screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
    app.whats_new.should == nil
    app.permissions.should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
    app.rating_distribution.should == {5=>5, 4=>0, 3=>0, 2=>1, 1=>0}
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
      result[:permissions].should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      result[:rating_distribution].should == {5=>5, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote'
      result[:rating].should == '4.7'
      result[:updated].should == 'July 17, 2013'
      result[:current_version].should == 'Varies with device'
      result[:requires_android].should == 'Varies with device'
      result[:category].should == 'Productivity'
      result[:size].should == 'Varies with device'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /New York Times/
      result[:votes].should == '630682'
      result[:developer].should == 'Evernote Corporation'
      result[:installs].should == '10,000,000 - 50,000,000'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/si0cgkp2rkVX5JhhBYrtZ4cy2I1hZcrx8aiz-v8MjvPykfhT7-YAM2B8MNi0OCF9AQ=w300'
      result[:banner_image_url].should == 'https://lh3.ggpht.com/si0cgkp2rkVX5JhhBYrtZ4cy2I1hZcrx8aiz-v8MjvPykfhT7-YAM2B8MNi0OCF9AQ=w300'
      result[:website_url].should == 'http://evernote.com/privacy/'
      result[:email].should == nil
      result[:youtube_video_ids].should == ['Ag_IGEgAa9M']
      result[:screenshot_urls].should == ["https://lh3.ggpht.com/54lY5NF-Af-oOCyW2JYhysfcFHiaXEgD6vj4PaaMMN9qopDKtgxD5R1Pufp7HErUBw=h310", "https://lh6.ggpht.com/jeIvDqZYde02771R9NHnEoNeNe0ulVk1oBlxCr5ksYx_KRKnhAUbeM1Sg22Wihx6xA=h310", "https://lh3.ggpht.com/YayoH5bQhg1Podr15Uv68daoM2u0v41VNF9LHVDNQ9cyPjUDBcO8byQ-m3jLfXOOdPY=h310", "https://lh5.ggpht.com/_nFgawWYq1g7Ohx88pv5zJCRNVjbw03sS7xgnodYPoyu-dQUTkre1X_kNJuQCdMG7wTt=h310", "https://lh4.ggpht.com/dIckq3oKvXckucvsb4UevalNvZIn19UM7kYT3_7kA7Vz-TTVQDIcN7TxR4GSxdVUmA=h310", "https://lh3.ggpht.com/NIm-_fgTbZJHV6ZN6BXkXBJEceUq98qxJEjeEt-3YXYrDcRmnsZ7v2p9wHFdqxCmdNk=h310", "https://lh6.ggpht.com/DaaxjGhsewYZYys5a4sCLmxQmCmpGlZH37GsUYVjgboCyTBarzhV2nrGbjBIo3jJxOS5=h310", "https://lh3.ggpht.com/fLSWe0AY9ERoT8RIjqnLi_oMX7QWheQ5mlNFX10R4_1nXfNhrniMMKwaOgzQXKKgUQ=h310"]
      result[:whats_new].should == "<div class=\"details-section-contents show-more-container\"> <div class=\"heading\"> What's New </div> <div class=\"recent-change\">New in Evernote</div>\n<div class=\"recent-change\">- Edit documents saved in Evernote using the OfficeSuite app</div>\n<div class=\"recent-change\">- Mark up attached PDFs with Skitch (Premium feature)</div>\n<div class=\"recent-change\">- Add a new Reminder right from the Reminders list</div>\n<div class=\"recent-change\">- Numerous performance and stability improvements</div>\n<div class=\"recent-change\">This update requires Android version 2.2 or newer</div>\n<div class=\"recent-change\">New in the Evernote Widget</div>\n<div class=\"recent-change\">- View notes in a list</div>\n<div class=\"recent-change\">- View and add Reminders</div>\n<div class=\"recent-change\">- Improved scaling for different screen heights</div>\n<div class=\"recent-change\">- Supports lock screen on Jelly Bean</div>\n<div class=\"recent-change\">This update requires Android version 3.0 or newer</div> <div class=\"show-more-end\"></div> <div> <div class=\"play-button show-more small\"> Read more </div> <div class=\"play-button expand-close\"> <div class=\"close-image\"> </div> </div> </div> </div> <div class=\"details-section-divider\"></div>"
      result[:permissions].should == [{:security=>"dangerous", :group=>"Hardware controls", :description=>"record audio", :description_full=>"Allows the app to access the audio record path."}, {:security=>"dangerous", :group=>"Hardware controls", :description=>"take pictures and videos", :description_full=>"Allows the app to take pictures and videos with the camera. This allows the app at any time to collect images the camera is seeing."}, {:security=>"dangerous", :group=>"Your location", :description=>"coarse (network-based) location", :description_full=>"Access coarse location sources such as the cellular network database to determine an approximate tablet location, where available. Malicious apps may use this to determine approximately where you are. Access coarse location sources such as the cellular network database to determine an approximate phone location, where available. Malicious apps may use this to determine approximately where you are."}, {:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read contact data", :description_full=>"Allows the app to read all of the contact (address) data stored on your tablet. Malicious apps may use this to send your data to other people. Allows the app to read all of the contact (address) data stored on your phone. Malicious apps may use this to send your data to other people."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read sensitive log data", :description_full=>"Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the tablet, potentially including personal or private information. Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the phone, potentially including personal or private information."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read calendar events plus confidential information", :description_full=>"Allows the app to read all calendar events stored on your tablet, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge. Allows the app to read all calendar events stored on your phone, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"dangerous", :group=>"Storage", :description=>"modify/delete USB storage contents modify/delete SD card contents", :description_full=>"Allows the app to write to the USB storage. Allows the app to write to the SD card."}, {:security=>"dangerous", :group=>"System tools", :description=>"prevent tablet from sleeping prevent phone from sleeping", :description_full=>"Allows the app to prevent the tablet from going to sleep. Allows the app to prevent the phone from going to sleep."}, {:security=>"safe", :group=>"Your accounts", :description=>"discover known accounts", :description_full=>"Allows the app to get the list of accounts known by the tablet. Allows the app to get the list of accounts known by the phone."}, {:security=>"safe", :group=>"Hardware controls", :description=>"control vibrator", :description_full=>"Allows the app to control the vibrator."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}, {:security=>"safe", :group=>"Network communication", :description=>"view Wi-Fi state", :description_full=>"Allows the app to view the information about the state of Wi-Fi."}, {:security=>"safe", :group=>"Default", :description=>"Market billing service", :description_full=>"Allows the user to purchase items through Market from within this application"}]
      result[:rating_distribution].should == {5=>263764, 4=>75499, 3=>9973, 2=>2385, 1=>4095}
      result[:html].should == test_src_data2
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data3)

      result[:title].should == 'Thermometer HD'
      result[:updated].should == 'May 11, 2012'
      result[:current_version].should == '1.5.2'
      result[:requires_android].should == '2.0 and up'
      result[:category].should == 'Weather'
      result[:size].should == '98k'
      result[:price].should == '$0.99'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^Want to know the up-to-date temperature and other weather/
      result[:developer].should == 'Kooistar Solutions'
      result[:rating].should == nil
      result[:votes].should == nil
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/XEJ1MZFUqXKDfTSwqpL8Apgo3qMAixdG3l_gt8FuFstGUd2vk7-qDIKH4fHRMi57-p4=w124'
      result[:banner_image_url].should == nil
      result[:website_url].should == 'http://www.donothave.com'
      result[:email].should == 'kooistar_solutions@hotmail.com'
      result[:youtube_video_ids].should == []
      result[:whats_new].should == "<p>What's in this version:</p>1.5.1: Bug fix: Exceptional case is catched now with an failure message + instruction.<br>1.5.2: Bug fix: Remove use of deprecated java funtion + catch null pointer -&gt; Better app<br>Thanks for reporting the bugs!<br>"
      result[:permissions].should == [{:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      result[:rating_distribution].should == {1=>nil, 2=>nil, 3=>nil, 4=>nil, 5=>nil}
      result[:html].should == test_src_data3
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      result[:related].should be_a(Array)
      result[:users_also_installed].should be_a(Array)
      result[:more_from_developer].should be_a(Array)

      result[:related].first[:app_id].should == 'com.evernote.world'
      result[:users_also_installed].first[:app_id].should == 'com.evernote.world'
      result[:more_from_developer].first[:app_id].should == 'com.evernote.widget'
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
