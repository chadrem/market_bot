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
    app.category.should == 'Arcade'
    app.category_url.should == 'GAME_ARCADE'
    app.installs.should == '500 - 1,000'
    app.size.should == '9.0M'
    app.price.should == '0'
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^<div.*?>An action-packed blend of split-second skill and luck-based gameplay!/
    app.votes.should == '8'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.users_also_installed.should == [{:app_id=>"stg.boomonline"}, {:app_id=>"vn.ibit.mazecity"}, {:app_id=>"net.simplexcode.bababoom"}]
    app.related.should == [{:app_id=>"stg.boomonline"}, {:app_id=>"vn.ibit.mazecity"}, {:app_id=>"net.simplexcode.bababoom"}]
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

    app.rating_distribution.should == {5=>7, 4=>0, 3=>0, 2=>1, 1=>0}
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
      result[:category].should == 'Arcade'
      result[:category_url].should == 'GAME_ARCADE'
      result[:installs].should == '500 - 1,000'
      result[:size].should == '9.0M'
      result[:price].should == '0'
      result[:content_rating].should == 'Everyone'
      result[:description].should =~ /An action-packed blend of split-second/
      result[:votes].should == '8'
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
      result[:rating_distribution].should == {5=>7, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote'
      result[:rating].should == '4.6'
      result[:updated].should == 'June 26, 2014'
      result[:current_version].should == 'Varies with device'
      result[:requires_android].should == 'Varies with device'
      result[:category].should == 'Productivity'
      result[:category_url].should == 'PRODUCTIVITY'
      result[:size].should == 'Varies with device'
      result[:price].should == '0'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /New York Times/
      result[:votes].should == '987819'
      result[:developer].should == 'Evernote Corporation'
      result[:installs].should == '50,000,000 - 100,000,000'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/si0cgkp2rkVX5JhhBYrtZ4cy2I1hZcrx8aiz-v8MjvPykfhT7-YAM2B8MNi0OCF9AQ=w300'
      result[:banner_image_url].should == 'https://lh3.ggpht.com/si0cgkp2rkVX5JhhBYrtZ4cy2I1hZcrx8aiz-v8MjvPykfhT7-YAM2B8MNi0OCF9AQ=w300'
      result[:website_url].should == 'http://evernote.com/privacy/'
      result[:email].should == nil
      result[:youtube_video_ids].should == ['Ag_IGEgAa9M']
      result[:screenshot_urls].should == ["https://lh3.ggpht.com/-uAQsDoqxCpENdxqX9PJ8uZMHVno-q_j7ys2t0u7ExRh9T5Lv839rIkGSrMNQ37SLX84=h310", "https://lh6.ggpht.com/nkot7aK-feeHWYMVFVesncWpwlc0u1qbs0XTrnpdp0agBSjIcngVBWjdYac02I48pA=h310", "https://lh5.ggpht.com/rodyOgoE6ckOEeWWqwMmkc8A_gQAdbPoUWxHsmjhRQh3pVDzaMOw4INtVqWCKetPq0o=h310", "https://lh4.ggpht.com/1taR7CXMM0NQxKFu_dkcfZoRKRm2TxpRubI2pUkT2rDuxcKp1QNAUgujIVQsAVtkL1w=h310", "https://lh3.ggpht.com/pSDOKGKQcC1GdEwcwkg8GR_s9vGkmsAis2cjgiioZRXh4DFjr0OWmwywEuQcwCo5mc8=h310", "https://lh4.ggpht.com/fCsV4Ngg32sUbr95rX2_eL-1OnW19cqsRdXmYhAJYYipS4oex2Ea8cwayUg_r1nJQy4=h310", "https://lh6.ggpht.com/kMxyXDioJ0g3Jpo8KnbUrts5XoIXHN_MKIRGzUzOgX8iW7ej_4r_L_0wWHGpFpx9jQ=h310", "https://lh4.ggpht.com/IG9xzoi6R6f0DlqKUHZWe3xTovKhzLZQWLpzU73s2D6nDRFrSrRtFKIOST5K8ksPgw=h310", "https://lh4.ggpht.com/RAVDjjjs_A0encFlwkAHiSn0afYnjmSgRx_p3WYPh9gvxJct3SoxiKE0F-sQNBnCaA=h310", "https://lh3.ggpht.com/zk3wB45O90a7qWe8LaXOpCJckFpS-Ukkih38Icq9SCry5pvmJfq0qpocuxZxXSYRJg=h310", "https://lh3.ggpht.com/xtSyEJsSKSMSjiVmtfZIQGxFI6T690aKJy4e6MhVGiFzOk44YCFcLkkhMDWjSqi3n_E=h310", "https://lh4.ggpht.com/2SMJhH9xCIpEvTlTevsMZI9xE2L_mWs79g1KyuGJ4kZ4VLP2NTu9UwKTndx6cRUkcz4=h310", "https://lh4.ggpht.com/a2dX7OdrMonXVW1jnBX1MAx6GlCW3DMwJSRPp787QQZYL_Nj0XmfTvWVr7OA0j4O3Q=h310", "https://lh5.ggpht.com/g9J-W-kAVR-FoSmuU3cPJYgiLLXJO3p9gbp-CL1upicwlyoyD3RPvGXhmExSNQIWIA=h310", "https://lh5.ggpht.com/EoPwnSqrjemPIv2TpBYY5GFFa6pQgVZZbiS7xFUbJgzND9WnvaNzRk9cE67NB08ERq8=h310"]
      result[:whats_new].should =~ /What's New/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Hardware controls", :description=>"record audio", :description_full=>"Allows the app to access the audio record path."}, {:security=>"dangerous", :group=>"Hardware controls", :description=>"take pictures and videos", :description_full=>"Allows the app to take pictures and videos with the camera. This allows the app at any time to collect images the camera is seeing."}, {:security=>"dangerous", :group=>"Your location", :description=>"coarse (network-based) location", :description_full=>"Access coarse location sources such as the cellular network database to determine an approximate tablet location, where available. Malicious apps may use this to determine approximately where you are. Access coarse location sources such as the cellular network database to determine an approximate phone location, where available. Malicious apps may use this to determine approximately where you are."}, {:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read contact data", :description_full=>"Allows the app to read all of the contact (address) data stored on your tablet. Malicious apps may use this to send your data to other people. Allows the app to read all of the contact (address) data stored on your phone. Malicious apps may use this to send your data to other people."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read sensitive log data", :description_full=>"Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the tablet, potentially including personal or private information. Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the phone, potentially including personal or private information."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read calendar events plus confidential information", :description_full=>"Allows the app to read all calendar events stored on your tablet, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge. Allows the app to read all calendar events stored on your phone, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"dangerous", :group=>"Storage", :description=>"modify/delete USB storage contents modify/delete SD card contents", :description_full=>"Allows the app to write to the USB storage. Allows the app to write to the SD card."}, {:security=>"dangerous", :group=>"System tools", :description=>"prevent tablet from sleeping prevent phone from sleeping", :description_full=>"Allows the app to prevent the tablet from going to sleep. Allows the app to prevent the phone from going to sleep."}, {:security=>"safe", :group=>"Your accounts", :description=>"discover known accounts", :description_full=>"Allows the app to get the list of accounts known by the tablet. Allows the app to get the list of accounts known by the phone."}, {:security=>"safe", :group=>"Hardware controls", :description=>"control vibrator", :description_full=>"Allows the app to control the vibrator."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}, {:security=>"safe", :group=>"Network communication", :description=>"view Wi-Fi state", :description_full=>"Allows the app to view the information about the state of Wi-Fi."}, {:security=>"safe", :group=>"Default", :description=>"Market billing service", :description_full=>"Allows the user to purchase items through Market from within this application"}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>731924, 4=>199038, 3=>31885, 2=>9166, 1=>15590}
      result[:html].should == test_src_data2
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data3)

      result[:title].should == 'WeatherPro'
      result[:updated].should == 'May 13, 2014'
      result[:current_version].should == '3.4.2'
      result[:requires_android].should == '2.1 and up'
      result[:category].should == 'Weather'
      result[:category_url].should == 'WEATHER'
      result[:size].should == '8.7M'
      result[:price].should == '$0.99'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^.*Plan your summer with WeatherPro! With the holidays just starting/
      result[:developer].should == 'MeteoGroup'
      result[:rating].should == "4.4"
      result[:votes].should == "28469"
      result[:banner_icon_url].should == 'https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300'
      result[:banner_image_url].should == 'https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300'
      result[:website_url].should == 'http://www.weatherpro.eu/privacy-policy.html'
      result[:email].should == 'support@android.weatherpro.de'
      result[:youtube_video_ids].should == []
      result[:whats_new].should =~ /Some minor improvements have been made to keep the app up-to-date/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>17860, 4=>7270, 3=>1476, 2=>635, 1=>1217}
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
