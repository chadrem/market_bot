require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = 'com.bluefroggaming.popdat'
test_src_data = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
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
    app.content_rating.should == 'Everyone'
    app.description.should =~ /^<div.*?>An action-packed blend of split-second skill and luck-based gameplay!/
    app.votes.should == '9'
    app.more_from_developer.should == [{:app_id=>"com.bluefroggaming.ghost_chicken"}]
    app.users_also_installed.should == [{:app_id=>"com.mac.warzonepaid"}, {:app_id=>"com.caresilabs.wheeljoy.paid"}, {:app_id=>"com.blazingsoft.crosswolf"}, {:app_id=>"org.vladest.Popcorn"}, {:app_id=>"com.mtb.dds"}, {:app_id=>"com.hdl.datbom"}, {:app_id=>"cz.dejvice.rc.Marvin"}, {:app_id=>"com.spectaculator.spectaculator"}, {:app_id=>"com.seleuco.xpectrum"}, {:app_id=>"app.usp"}, {:app_id=>"com.fms.speccy"}, {:app_id=>"com.reynoldssoft.sampler"}, {:app_id=>"com.dylanpdx.blockybird"}]
    app.related.should == [{:app_id=>"com.mac.warzonepaid"}, {:app_id=>"com.caresilabs.wheeljoy.paid"}, {:app_id=>"com.blazingsoft.crosswolf"}, {:app_id=>"org.vladest.Popcorn"}, {:app_id=>"com.mtb.dds"}, {:app_id=>"com.hdl.datbom"}, {:app_id=>"cz.dejvice.rc.Marvin"}, {:app_id=>"com.spectaculator.spectaculator"}, {:app_id=>"com.seleuco.xpectrum"}, {:app_id=>"app.usp"}, {:app_id=>"com.fms.speccy"}, {:app_id=>"com.reynoldssoft.sampler"}, {:app_id=>"com.dylanpdx.blockybird"}]
    app.banner_icon_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.banner_image_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.website_url.should == 'http://bluefroggaming.com'
    app.email.should == 'support@hdgames.zendesk.com'
    app.youtube_video_ids.should == []
    app.screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
    app.full_screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h900", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h900", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h900", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h900", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h900"]
    app.whats_new.should == nil
    #app.permissions.should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
    # Stubbing out for now, can't find them in the redesigned page.
    app.permissions.should == []

    app.rating_distribution.should == {5=>8, 4=>0, 3=>0, 2=>1, 1=>0}
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
      result[:rating].should == '4.7'
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
      result[:votes].should == '9'
      result[:developer].should == 'Blue Frog Gaming'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
      result[:website_url].should == 'http://bluefroggaming.com'
      result[:email].should == 'support@hdgames.zendesk.com'
      result[:youtube_video_ids].should == []
      result[:screenshot_urls].should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
      result[:full_screenshot_urls].should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h900", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h900", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h900", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h900", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h900"]      
      result[:whats_new].should == nil
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>8, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data

      result
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data2)

      result[:title].should == 'Evernote'
      result[:rating].should == '4.6'
      result[:updated].should == 'November 26, 2014'
      result[:current_version].should == 'Varies with device'
      result[:requires_android].should == 'Varies with device'
      result[:category].should == 'Productivity'
      result[:category_url].should == 'PRODUCTIVITY'
      result[:size].should == 'Varies with device'
      result[:price].should == '0'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /New York Times/
      result[:votes].should == '1134111'
      result[:developer].should == 'Evernote Corporation'
      result[:installs].should == '50,000,000 - 100,000,000'
      result[:banner_icon_url].should == 'https://lh5.ggpht.com/u_ZwBnOs3s7nHA2v4XDCrJknAAVVHQIzK4mVF8tbx1n62-_LrDSopwHviqeNuDIFigc=w300'
      result[:banner_image_url].should == 'https://lh5.ggpht.com/u_ZwBnOs3s7nHA2v4XDCrJknAAVVHQIzK4mVF8tbx1n62-_LrDSopwHviqeNuDIFigc=w300'
      result[:website_url].should == 'http://evernote.com/privacy/'
      result[:email].should == 'appstore-evernote-android@evernote.com'
      result[:youtube_video_ids].should == ['UnpUIVO8Lmo']
      result[:screenshot_urls].should == ["https://lh5.ggpht.com/PVFHj_lDlc52wwNu0by2CLmUrSHaAx6NINjbe9qmk-NPo-S5UUA8oghVARMBHEWgXDU=h310", "https://lh5.ggpht.com/KvbOit3FFnfbOZ6rG23sDEVuC4ALtLGV0Q0zwu6vMKDCO4u69_zI-IhmD3jOGuJLEj4=h310", "https://lh5.ggpht.com/TEWuyLgIH6_514_1xpcqpcjFPSxu82Sak2RPuwbtexRqe-kJuW81DF5IRdS4Lis1KJQ=h310", "https://lh4.ggpht.com/KeGMsBnchmH9gywdjA1x7fqUpQX0UrMA_cMZbvr2hYHLiYTsCKOescqniEO4DItuHxU=h310", "https://lh5.ggpht.com/zWJ3VVV-sjT0mSADljAMyecO3QmcoFBtLBs8bETznU49X8avDRv3_iF5TkJkzVlu8qU=h310", "https://lh5.ggpht.com/3DqrNu-AHqGQQTDper8eTzpm9XEUNq605BxNSCkx4yGopa9u0TD2jBPHXdgwEPp08A=h310", "https://lh6.ggpht.com/9h0D2tvXlf6oLsylnNaaSdxjmm6rJuWeHvML-8zg5xoTp4akAjSXRCylxvF_dNTfoTU=h310", "https://lh5.ggpht.com/ugk2h_v0RrvAdzL7FfqD4jBONrfzboL6eAuFmkqvWg7zQiJUvkz6GThCU5pnKzCmRA=h310", "https://lh4.ggpht.com/3QUx47b-R9ex02vhUDH8h2hN3VDgS7e7rNAP7JCPaxaXr-GClb7jsZEsAyIr5iiwzw=h310", "https://lh5.ggpht.com/1LW-N8yEdwS1s-ZuvQSzqNMLaLldL8wBdLHhDY9TvPV8NnxBWIUjVaDZuat8I7V5uh4=h310", "https://lh4.ggpht.com/hIueHCJKvvAUrTrQQSSv6-2zpKMV-fdTIITHhMGfrulky5fEAR6KM1cpyUFD_9_kqw=h310", "https://lh4.ggpht.com/l-rQJVY9d2ZYZXWXnKfLUkTk6gGCE79Xopb__YlFeVZ974PBgfF4lK8olU67TvK3-g=h310", "https://lh4.ggpht.com/Q_2sTO9l0OIdDv801S2mlJI-vugeKROHHyPcWf7Hvavs5d-MU2v2RWS6sUOrF79gH1Hn=h310", "https://lh5.ggpht.com/1O17OJEpW3qZcyEyfljRcIHUIIAOiBlCc5SxHPghyv0evV4h2g-ZooBAL3xkog-kZYU=h310", "https://lh6.ggpht.com/nyn0trJ4OTdpb3SkH7ItJu8W4DdFNNW9P2AAr0OBA9q0H7y8KLxtc144tlSZXQIVKjE=h310", "https://lh6.ggpht.com/Yo4DN_K0v27ltrEEmJxI9XHn_BtGIgH6kLkxG3hG8Q0PeCJPpDv0FzDXLxbK2gkx0wY=h310"]
      result[:full_screenshot_urls].should == ["https://lh5.ggpht.com/PVFHj_lDlc52wwNu0by2CLmUrSHaAx6NINjbe9qmk-NPo-S5UUA8oghVARMBHEWgXDU=h900", "https://lh5.ggpht.com/KvbOit3FFnfbOZ6rG23sDEVuC4ALtLGV0Q0zwu6vMKDCO4u69_zI-IhmD3jOGuJLEj4=h900", "https://lh5.ggpht.com/TEWuyLgIH6_514_1xpcqpcjFPSxu82Sak2RPuwbtexRqe-kJuW81DF5IRdS4Lis1KJQ=h900", "https://lh4.ggpht.com/KeGMsBnchmH9gywdjA1x7fqUpQX0UrMA_cMZbvr2hYHLiYTsCKOescqniEO4DItuHxU=h900", "https://lh5.ggpht.com/zWJ3VVV-sjT0mSADljAMyecO3QmcoFBtLBs8bETznU49X8avDRv3_iF5TkJkzVlu8qU=h900", "https://lh5.ggpht.com/3DqrNu-AHqGQQTDper8eTzpm9XEUNq605BxNSCkx4yGopa9u0TD2jBPHXdgwEPp08A=h900", "https://lh6.ggpht.com/9h0D2tvXlf6oLsylnNaaSdxjmm6rJuWeHvML-8zg5xoTp4akAjSXRCylxvF_dNTfoTU=h900", "https://lh5.ggpht.com/ugk2h_v0RrvAdzL7FfqD4jBONrfzboL6eAuFmkqvWg7zQiJUvkz6GThCU5pnKzCmRA=h900", "https://lh4.ggpht.com/3QUx47b-R9ex02vhUDH8h2hN3VDgS7e7rNAP7JCPaxaXr-GClb7jsZEsAyIr5iiwzw=h900", "https://lh5.ggpht.com/1LW-N8yEdwS1s-ZuvQSzqNMLaLldL8wBdLHhDY9TvPV8NnxBWIUjVaDZuat8I7V5uh4=h900", "https://lh4.ggpht.com/hIueHCJKvvAUrTrQQSSv6-2zpKMV-fdTIITHhMGfrulky5fEAR6KM1cpyUFD_9_kqw=h900", "https://lh4.ggpht.com/l-rQJVY9d2ZYZXWXnKfLUkTk6gGCE79Xopb__YlFeVZ974PBgfF4lK8olU67TvK3-g=h900", "https://lh4.ggpht.com/Q_2sTO9l0OIdDv801S2mlJI-vugeKROHHyPcWf7Hvavs5d-MU2v2RWS6sUOrF79gH1Hn=h900", "https://lh5.ggpht.com/1O17OJEpW3qZcyEyfljRcIHUIIAOiBlCc5SxHPghyv0evV4h2g-ZooBAL3xkog-kZYU=h900", "https://lh6.ggpht.com/nyn0trJ4OTdpb3SkH7ItJu8W4DdFNNW9P2AAr0OBA9q0H7y8KLxtc144tlSZXQIVKjE=h900", "https://lh6.ggpht.com/Yo4DN_K0v27ltrEEmJxI9XHn_BtGIgH6kLkxG3hG8Q0PeCJPpDv0FzDXLxbK2gkx0wY=h900"]
      result[:whats_new].should =~ /What's New/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Hardware controls", :description=>"record audio", :description_full=>"Allows the app to access the audio record path."}, {:security=>"dangerous", :group=>"Hardware controls", :description=>"take pictures and videos", :description_full=>"Allows the app to take pictures and videos with the camera. This allows the app at any time to collect images the camera is seeing."}, {:security=>"dangerous", :group=>"Your location", :description=>"coarse (network-based) location", :description_full=>"Access coarse location sources such as the cellular network database to determine an approximate tablet location, where available. Malicious apps may use this to determine approximately where you are. Access coarse location sources such as the cellular network database to determine an approximate phone location, where available. Malicious apps may use this to determine approximately where you are."}, {:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read contact data", :description_full=>"Allows the app to read all of the contact (address) data stored on your tablet. Malicious apps may use this to send your data to other people. Allows the app to read all of the contact (address) data stored on your phone. Malicious apps may use this to send your data to other people."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read sensitive log data", :description_full=>"Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the tablet, potentially including personal or private information. Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the phone, potentially including personal or private information."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read calendar events plus confidential information", :description_full=>"Allows the app to read all calendar events stored on your tablet, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge. Allows the app to read all calendar events stored on your phone, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"dangerous", :group=>"Storage", :description=>"modify/delete USB storage contents modify/delete SD card contents", :description_full=>"Allows the app to write to the USB storage. Allows the app to write to the SD card."}, {:security=>"dangerous", :group=>"System tools", :description=>"prevent tablet from sleeping prevent phone from sleeping", :description_full=>"Allows the app to prevent the tablet from going to sleep. Allows the app to prevent the phone from going to sleep."}, {:security=>"safe", :group=>"Your accounts", :description=>"discover known accounts", :description_full=>"Allows the app to get the list of accounts known by the tablet. Allows the app to get the list of accounts known by the phone."}, {:security=>"safe", :group=>"Hardware controls", :description=>"control vibrator", :description_full=>"Allows the app to control the vibrator."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}, {:security=>"safe", :group=>"Network communication", :description=>"view Wi-Fi state", :description_full=>"Allows the app to view the information about the state of Wi-Fi."}, {:security=>"safe", :group=>"Default", :description=>"Market billing service", :description_full=>"Allows the user to purchase items through Market from within this application"}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>833055, 4=>229395, 3=>39241, 2=>12003, 1=>20202}
      result[:html].should == test_src_data2
    end

    it 'should populate a hash with the correct keys/values' do
      result = App.parse(test_src_data3)

      result[:title].should == 'WeatherPro'
      result[:updated].should == 'October 1, 2014'
      result[:current_version].should == '3.5.2'
      result[:requires_android].should == '2.3 and up'
      result[:category].should == 'Weather'
      result[:category_url].should == 'WEATHER'
      result[:size].should == '9.1M'
      result[:price].should == '$2.99'
      result[:content_rating].should == 'Low Maturity'
      result[:description].should =~ /^.*WeatherPro answers the question - what's the best Android Weather app/
      result[:developer].should == 'MeteoGroup'
      result[:rating].should == "4.4"
      result[:votes].should == "32543"
      result[:banner_icon_url].should == 'https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300'
      result[:banner_image_url].should == 'https://lh5.ggpht.com/gEwuqrqo9Hu2qRNfBi8bLs0XByBQEmhvBhyNXJLuPmrT47GNfljir8ddam-Plzhovrg=w300'
      result[:website_url].should == 'http://www.meteogroup.com/en/gb/about-meteogroup/privacy-policy-and-cookies.html'
      result[:email].should == 'support@android.weatherpro.de'
      result[:youtube_video_ids].should == []
      result[:whats_new].should =~ /Access to WeatherPro app via car infotainment screen/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>20184, 4=>8344, 3=>1749, 2=>801, 1=>1454}
      result[:html].should == test_src_data3
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      result[:related].should be_a(Array)
      result[:users_also_installed].should be_a(Array)
      result[:more_from_developer].should be_a(Array)

      result[:related].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:users_also_installed].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:more_from_developer].first[:app_id].should == 'com.evernote.widget'
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
