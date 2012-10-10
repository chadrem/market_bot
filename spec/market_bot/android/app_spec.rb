require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = 'com.bluefroggaming.popdat'
test_src_data = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
test_src_data2 = read_file(File.dirname(__FILE__), 'data', 'app_2.txt')
test_src_data3 = read_file(File.dirname(__FILE__), 'data', 'app_3.txt')

def check_getters(app)
  it 'should populate the getters' do
    app.title.should == 'Pop Dat'
    app.rating.should == '4.5'
    app.updated.should == 'August 27, 2011'
    app.current_version.should == '1.0'
    app.requires_android.should == '2.2 and up'
    app.category.should == 'Arcade & Action'
    app.installs.should == '100 - 500'
    app.size.should == '9.0M'
    app.price.should == 'Free'
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^Experience the next level of chain/
    app.votes.should == '6'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.users_also_installed.should == [{:app_id=>"com.mudstuffingindustries.redneckjellyfish"}, {:app_id=>"com.lyote.blurt"}, {:app_id=>"com.donutman.rosham"}, {:app_id=>"jscompany.games.separatetrash_lite"}]
    app.related.should == [{:app_id=>"com.popcasuals.bubblepop2"}, {:app_id=>"com.jakyl.aftermathxhd"}, {:app_id=>"com.lsgvgames.slideandflyfull"}, {:app_id=>"com.rubicon.dev.glwg"}]
    app.banner_icon_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w124'
    app.banner_image_url.should == 'https://lh6.ggpht.com/hh-pkbt1mEbFg7CJt2DSum7WDtnKS8jWPYrMwPbE2LY_qvNQa6CZLpseQHX6PVJ1RA=w705'
    app.website_url.should == 'http://bluefroggaming.com'
    app.email.should == 'support@hdgames.zendesk.com'
    app.youtube_video_ids.should == []
    app.screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h230", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h230", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h230", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h230", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h230", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h230"]
    app.whats_new.should == "<div class=\"doc-permissions\">No recent changes.</div>"
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
      result[:rating].should == '4.5'
      result[:updated].should == 'August 27, 2011'
      result[:current_version].should == '1.0'
      result[:requires_android].should == '2.2 and up'
      result[:category].should == 'Arcade & Action'
      result[:installs].should == '100 - 500'
      result[:size].should == '9.0M'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /^Experience the next level of chain/
      result[:votes].should == '6'
      result[:developer].should == 'Blue Frog Gaming'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w124'
      result[:website_url].should == 'http://bluefroggaming.com'
      result[:email].should == 'support@hdgames.zendesk.com'
      result[:youtube_video_ids].should == []
      result[:screenshot_urls].should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h230", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h230", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h230", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h230", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h230", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h230"]
      result[:whats_new].should == "<div class=\"doc-permissions\">No recent changes.</div>"
      result[:permissions].should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      result[:rating_distribution].should == {5=>5, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote'
      result[:rating].should == '4.7'
      result[:updated].should == 'July 25, 2012'
      result[:current_version].should == '4.1.1'
      result[:requires_android].should == '1.6 and up'
      result[:category].should == 'Productivity'
      result[:size].should == '7.5M'
      result[:price].should == 'Free'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^Evernote turns your Android device into an extension/
      result[:votes].should == '355,716'
      result[:developer].should == 'Evernote Corp.'
      result[:installs].should == '10,000,000 - 50,000,000'
      result[:banner_icon_url].should == 'https://lh4.ggpht.com/YpRePJZ4TJUCdERkX-E0uUq6jhaofOS1szIejmo3DZm4oEq82AqcUpoj9FHOxFRvprU=w124'
      result[:banner_image_url].should == 'https://lh5.ggpht.com/TlPZORLq1sFgdJhvySRCcmw2Ybd6gSlhGSQuPNZJvQWjG1yWemfAEC9HL1Q288mMUNjE=w705'
      result[:website_url].should == 'http://www.evernote.com'
      result[:email].should == nil
      result[:youtube_video_ids].should == ['Ag_IGEgAa9M']
      result[:screenshot_urls].should == ["https://lh3.ggpht.com/Q_vPAtKVUefD3znGi_8AnK3FHDf8XsegMnVrX2sImaFLKXOC__MWKXW2WY1avhlvF_aK=h230", "https://lh6.ggpht.com/nbz5tSvuuydrcQ5kl2PpaFuPBrEgXRPaEXXecLMNXEGVblUlDoTXCRH22GrM2RYFcA=h230", "https://lh3.ggpht.com/Oi0lpkA23XsHjg_cXyXkOaRtNw84_OR_YtzhZUCe8VhWRej8oCT28I0VD8Z5ixSuCyM=h230", "https://lh4.ggpht.com/EfNdIkRr5T0JQQlvPICl6m3gHCDBEnsMxqZMrXb0qMW9xBQCN10PaPdrKVI-07XzsXs=h230", "https://lh4.ggpht.com/Q4BDQRkuvHMglh5I0aG56Yy_29NnBWxXWTqkv21onHM41pnrHoLnkacQFmqr6SVtuUR4=h230", "https://lh3.ggpht.com/Uf4MqnyMPVEFATlkutnXVyBtUQEkJbBLQREXbBI633wHAeBxhAc2-XSuysMM5ZFC7f7j=h230", "https://lh4.ggpht.com/02wkEgVmPPLwcMJc_YPnXpiYf3v3obz9yf2SIC7WwLVYjjYHJB48DFioTyAbbS1xiw=h230", "https://lh5.ggpht.com/k6LCn2yoTQH3ofLr4uycKRnhDZTvB9RcPlyIrUIaIpFSgHcAz4_2LKQfSZPC44YFxw=h230"]
      result[:whats_new].should == "<p>What's in this version:</p>Major Android tablet enhancements!<br>- Completely new tablet look and feel<br>New home screen lets you create and find your notes easily<br>- Swipe navigation on tablets<br>Swipe right to jump to the home screen from a note or note list<br>- Space-saving List View on tablets<br>Phone and tablet improvements:<br>- Create sublists<br>Add levels to your lists by tapping the arrows in the formatting bar when the cursor is in an existing list<br>"
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

      result[:related].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:users_also_installed].first[:app_id].should == 'com.acadoid.lecturenotes'
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
