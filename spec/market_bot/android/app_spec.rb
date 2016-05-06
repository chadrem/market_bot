require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = 'com.bluefroggaming.popdat'
test_src_data = read_file(File.dirname(__FILE__), 'data', 'app_1.txt')
test_src_data2 = read_file(File.dirname(__FILE__), 'data', 'app_2.txt')
test_src_data3 = read_file(File.dirname(__FILE__), 'data', 'app_3.txt')
test_src_data4 = read_file(File.dirname(__FILE__), 'data', 'app_4.txt')

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
    app.users_also_installed.should == [{:app_id=>"si.custom.snake"}]
    app.related.should == [{:app_id=>"si.custom.snake"}]
    app.banner_icon_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.banner_image_url.should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
    app.website_url.should == 'http://bluefroggaming.com'
    app.email.should == 'support@hdgames.zendesk.com'
    app.screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
    app.full_screenshot_urls.should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h900", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h900", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h900", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h900", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h900"]
    app.whats_new.should == nil
    #app.permissions.should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
    # Stubbing out for now, can't find them in the redesigned page.
    app.permissions.should == []

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
      result[:content_rating].should == 'Unrated'
      result[:description].should =~ /An action-packed blend of split-second/
      result[:votes].should == '11'
      result[:developer].should == 'Blue Frog Gaming'
      result[:banner_icon_url].should == 'https://lh3.ggpht.com/e6QqjMM9K__moeCm2C5HRb0SmGX0XqzhnhiE1MUx8MdNVdQbQW9rhFX_qmtbtBxHAa0=w300'
      result[:website_url].should == 'http://bluefroggaming.com'
      result[:email].should == 'support@hdgames.zendesk.com'
      result[:screenshot_urls].should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h310", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h310", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h310", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h310", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h310", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h310"]
      result[:full_screenshot_urls].should == ["https://lh6.ggpht.com/JJWPKPEvz5ivZEeph_gA_oB3VOXYrIrY9lGdGFWHVT4FVub6cUKqxkh5VyxbvVqMXg=h900", "https://lh6.ggpht.com/kPGbJqu42Ukxoa_XZlWxo349y3zNKCayjBD35V2bbt26ZmgpHDegTf8sS5C1VOoAiw=h900", "https://lh3.ggpht.com/S9VMzKxAWSS3IxeUtLYPn-zDg9ojTpVxeHbd3RhHqtXazGRV6-S0jsuNh-GneV9eE2A=h900", "https://lh5.ggpht.com/G0U5k5PpvuEdflN58qzr3uKHGsXk3QqwwLIL_KxVfGNicR7Gn42smetbTBn9SRftnyk=h900", "https://lh6.ggpht.com/j03lPKqJss6066_Q6AbZikU33PWgoR07cPLFgoE5IoNyXwMG6QVX_3-SgI741vnaVnu7=h900", "https://lh3.ggpht.com/YBrG1Hjv7vgNLwp9PaR77gQHwdpInuluSnq9qPG4BwwU7LItCy4m6RQt9YM1sJH1hjdq=h900"]
      result[:whats_new].should == nil
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>10, 4=>0, 3=>0, 2=>1, 1=>0}
      result[:html].should == test_src_data

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
      result[:screenshot_urls].should == ["https://lh3.googleusercontent.com/AkEKnkvCyM6e-FS5RT5DExb56uCUDc1S0cc3sI4IORrJAT-HTLQz-jPu8whw-BL5oA=h310", "https://lh3.googleusercontent.com/qGb8MRDdS4T5pCepmVDWUy7si-fNddvsGLaF3rPYXlB89FjYa_on4VBp-8xPIKq5Qk9C=h310", "https://lh3.googleusercontent.com/N2IqJKGd9-pgW0HgRQhoSA9UNXZFV4OYVIv7l8mhyNmZESVGEywiXviU4OoMbeDqPg=h310", "https://lh3.googleusercontent.com/FfN8xU2ePAfgOCWIyBf-qkYKWk-ALKOwq0Y3F65NutRLF6YrrV-K2udP6xXP2k5PIRE=h310", "https://lh3.googleusercontent.com/9npD1H7xz7NwtyfM9cCOTaYSpqaXQMAWJGYh13q4_F1Kz1TfyWkz9ba0yWc6r6Wwbi8=h310", "https://lh3.googleusercontent.com/InW32sC2LFGHK3gqMT4rTYvu0XqR3ZBPE21Gsp2HAu3O5ilYG1Gi2t3klF_8_OPwQYM=h310", "https://lh3.googleusercontent.com/FX59DjcMqjEj01oGatPAQPZxXuD8A8xVYtpeArc1ECRcLueVJNHykTKw4TgnJSMPpzI=h310", "https://lh3.googleusercontent.com/fYrp0ou-qf5P-LXmUx6w54buL_WO3P4zaa68ULGP98zQirZr68PDdICQfq8bxmRoAA=h310", "https://lh3.googleusercontent.com/fg_VM5xXZqfr8npJm7Cc64Tf5N2Pb-lNkt88y2kjb_gObfXh1vbB9LA_jFYpyi2nxvFa=h310", "https://lh3.googleusercontent.com/-sYE4X1Ua6hM0TwBeZJf6OqT-8OZTI8lZx9TEbgnBlpIdoomaBORAoOqYii2a7FV6g=h310", "https://lh3.googleusercontent.com/pI8Gcd_S3gyVRlztODJ8rdZYD6sD1k36tbrvd4yY0n3vCU6_GCKIn-XyNiE3l1oDf-A=h310", "https://lh3.googleusercontent.com/GoDuyxtSwVzL6GAtT8O9JzV2ulaOFbUTHV0fQtMCrpLrxek4dsUzahnPs0eAd0-YC05z=h310", "https://lh3.googleusercontent.com/pGAi_1d2FlXhwJggTJFm_23pmhRmiGdBngjxmIiHUAwFYzrPizkZyxE7Srq_WzBs-Fpy=h310", "https://lh3.googleusercontent.com/85hsOFhv0fTSTxLmgRTEIdg5m8jFFnbMVcwWKzkeHxQ7MxaTpvdBkEcobteiEnZbGwI=h310", "https://lh3.googleusercontent.com/yNsucoQ93ZCDHSocqcPbvKL9J1KHruCvkzgpbqZwoXFX_cWQsHc81PR2kNemT6hBlw=h310", "https://lh3.googleusercontent.com/aIOqnxGnBOrJGqrSNFpay91nRdwcDXjbX1iQiY4Oepf3VUwqxFyCgD6GKauJ5LD0VA=h310", "https://lh3.googleusercontent.com/Ve7cJfhPpwMxeK350SAfYqCX9wbjdvtTgFb51cJI_IIBy-ciqrSh12XA3BAB-zWmaX4=h310", "https://lh3.googleusercontent.com/JKxZgzgcMX6B2UjuwHU3fFH20aqM6oBjdaugW_NRPinu1VL28Zsb0tOFmRLcg3hI2U8=h310", "https://lh3.googleusercontent.com/Y5V6rb-0fib5I4hufNdY5sSUE_ygvQNy2KO-PcGAR2xh5ciPrcbc3yLoWe-2blIQvw=h310", "https://lh3.googleusercontent.com/Onf1DjVvgdpmue7R8TtZ56wM3SNOD_VCxGshZX1hPnLHpMA7l6n3fQWXva7U7qjdy5ya=h310", "https://lh3.googleusercontent.com/gZCFLqggz9SCqzObmTQw_xXfBv9N7iXiEqUp2iHYwaqFBmpmgTYOaRllCF5VVGLkg0g=h310", "https://lh3.googleusercontent.com/VAYeCD2aIkR-EcF1-48ViOg0ZdYVAC-YU3wIVnDkp7GtxZh3tnv7rDRh_Fvtj-jM098g=h310", "https://lh3.googleusercontent.com/yj50UFheAT_1ZOvZGUOs8VjL6499391RB_x5LUNfpPW2enUcm_Lt95Bcih_AJ8VzpHI=h310", "https://lh3.googleusercontent.com/JO_h9TGYQOqyzCLhIWlLVkzF2DZc1Ib1kIOxg0WVIcH0tOuKPLQApxMxTywChqCa2A=h310"]
      result[:full_screenshot_urls].should == ["https://lh3.googleusercontent.com/AkEKnkvCyM6e-FS5RT5DExb56uCUDc1S0cc3sI4IORrJAT-HTLQz-jPu8whw-BL5oA=h900", "https://lh3.googleusercontent.com/qGb8MRDdS4T5pCepmVDWUy7si-fNddvsGLaF3rPYXlB89FjYa_on4VBp-8xPIKq5Qk9C=h900", "https://lh3.googleusercontent.com/N2IqJKGd9-pgW0HgRQhoSA9UNXZFV4OYVIv7l8mhyNmZESVGEywiXviU4OoMbeDqPg=h900", "https://lh3.googleusercontent.com/FfN8xU2ePAfgOCWIyBf-qkYKWk-ALKOwq0Y3F65NutRLF6YrrV-K2udP6xXP2k5PIRE=h900", "https://lh3.googleusercontent.com/9npD1H7xz7NwtyfM9cCOTaYSpqaXQMAWJGYh13q4_F1Kz1TfyWkz9ba0yWc6r6Wwbi8=h900", "https://lh3.googleusercontent.com/InW32sC2LFGHK3gqMT4rTYvu0XqR3ZBPE21Gsp2HAu3O5ilYG1Gi2t3klF_8_OPwQYM=h900", "https://lh3.googleusercontent.com/FX59DjcMqjEj01oGatPAQPZxXuD8A8xVYtpeArc1ECRcLueVJNHykTKw4TgnJSMPpzI=h900", "https://lh3.googleusercontent.com/fYrp0ou-qf5P-LXmUx6w54buL_WO3P4zaa68ULGP98zQirZr68PDdICQfq8bxmRoAA=h900", "https://lh3.googleusercontent.com/fg_VM5xXZqfr8npJm7Cc64Tf5N2Pb-lNkt88y2kjb_gObfXh1vbB9LA_jFYpyi2nxvFa=h900", "https://lh3.googleusercontent.com/-sYE4X1Ua6hM0TwBeZJf6OqT-8OZTI8lZx9TEbgnBlpIdoomaBORAoOqYii2a7FV6g=h900", "https://lh3.googleusercontent.com/pI8Gcd_S3gyVRlztODJ8rdZYD6sD1k36tbrvd4yY0n3vCU6_GCKIn-XyNiE3l1oDf-A=h900", "https://lh3.googleusercontent.com/GoDuyxtSwVzL6GAtT8O9JzV2ulaOFbUTHV0fQtMCrpLrxek4dsUzahnPs0eAd0-YC05z=h900", "https://lh3.googleusercontent.com/pGAi_1d2FlXhwJggTJFm_23pmhRmiGdBngjxmIiHUAwFYzrPizkZyxE7Srq_WzBs-Fpy=h900", "https://lh3.googleusercontent.com/85hsOFhv0fTSTxLmgRTEIdg5m8jFFnbMVcwWKzkeHxQ7MxaTpvdBkEcobteiEnZbGwI=h900", "https://lh3.googleusercontent.com/yNsucoQ93ZCDHSocqcPbvKL9J1KHruCvkzgpbqZwoXFX_cWQsHc81PR2kNemT6hBlw=h900", "https://lh3.googleusercontent.com/aIOqnxGnBOrJGqrSNFpay91nRdwcDXjbX1iQiY4Oepf3VUwqxFyCgD6GKauJ5LD0VA=h900", "https://lh3.googleusercontent.com/Ve7cJfhPpwMxeK350SAfYqCX9wbjdvtTgFb51cJI_IIBy-ciqrSh12XA3BAB-zWmaX4=h900", "https://lh3.googleusercontent.com/JKxZgzgcMX6B2UjuwHU3fFH20aqM6oBjdaugW_NRPinu1VL28Zsb0tOFmRLcg3hI2U8=h900", "https://lh3.googleusercontent.com/Y5V6rb-0fib5I4hufNdY5sSUE_ygvQNy2KO-PcGAR2xh5ciPrcbc3yLoWe-2blIQvw=h900", "https://lh3.googleusercontent.com/Onf1DjVvgdpmue7R8TtZ56wM3SNOD_VCxGshZX1hPnLHpMA7l6n3fQWXva7U7qjdy5ya=h900", "https://lh3.googleusercontent.com/gZCFLqggz9SCqzObmTQw_xXfBv9N7iXiEqUp2iHYwaqFBmpmgTYOaRllCF5VVGLkg0g=h900", "https://lh3.googleusercontent.com/VAYeCD2aIkR-EcF1-48ViOg0ZdYVAC-YU3wIVnDkp7GtxZh3tnv7rDRh_Fvtj-jM098g=h900", "https://lh3.googleusercontent.com/yj50UFheAT_1ZOvZGUOs8VjL6499391RB_x5LUNfpPW2enUcm_Lt95Bcih_AJ8VzpHI=h900", "https://lh3.googleusercontent.com/JO_h9TGYQOqyzCLhIWlLVkzF2DZc1Ib1kIOxg0WVIcH0tOuKPLQApxMxTywChqCa2A=h900"]
      result[:whats_new].should =~ /What's New/
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Hardware controls", :description=>"record audio", :description_full=>"Allows the app to access the audio record path."}, {:security=>"dangerous", :group=>"Hardware controls", :description=>"take pictures and videos", :description_full=>"Allows the app to take pictures and videos with the camera. This allows the app at any time to collect images the camera is seeing."}, {:security=>"dangerous", :group=>"Your location", :description=>"coarse (network-based) location", :description_full=>"Access coarse location sources such as the cellular network database to determine an approximate tablet location, where available. Malicious apps may use this to determine approximately where you are. Access coarse location sources such as the cellular network database to determine an approximate phone location, where available. Malicious apps may use this to determine approximately where you are."}, {:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read contact data", :description_full=>"Allows the app to read all of the contact (address) data stored on your tablet. Malicious apps may use this to send your data to other people. Allows the app to read all of the contact (address) data stored on your phone. Malicious apps may use this to send your data to other people."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read sensitive log data", :description_full=>"Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the tablet, potentially including personal or private information. Allows the app to read from the system's various log files. This allows it to discover general information about what you are doing with the phone, potentially including personal or private information."}, {:security=>"dangerous", :group=>"Your personal information", :description=>"read calendar events plus confidential information", :description_full=>"Allows the app to read all calendar events stored on your tablet, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge. Allows the app to read all calendar events stored on your phone, including those of friends or coworkers. Malicious apps may extract personal information from these calendars without the owners' knowledge."}, {:security=>"dangerous", :group=>"Phone calls", :description=>"read phone state and identity", :description_full=>"Allows the app to access the phone features of the device. An app with this permission can determine the phone number and serial number of this phone, whether a call is active, the number that call is connected to and the like."}, {:security=>"dangerous", :group=>"Storage", :description=>"modify/delete USB storage contents modify/delete SD card contents", :description_full=>"Allows the app to write to the USB storage. Allows the app to write to the SD card."}, {:security=>"dangerous", :group=>"System tools", :description=>"prevent tablet from sleeping prevent phone from sleeping", :description_full=>"Allows the app to prevent the tablet from going to sleep. Allows the app to prevent the phone from going to sleep."}, {:security=>"safe", :group=>"Your accounts", :description=>"discover known accounts", :description_full=>"Allows the app to get the list of accounts known by the tablet. Allows the app to get the list of accounts known by the phone."}, {:security=>"safe", :group=>"Hardware controls", :description=>"control vibrator", :description_full=>"Allows the app to control the vibrator."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}, {:security=>"safe", :group=>"Network communication", :description=>"view Wi-Fi state", :description_full=>"Allows the app to view the information about the state of Wi-Fi."}, {:security=>"safe", :group=>"Default", :description=>"Market billing service", :description_full=>"Allows the user to purchase items through Market from within this application"}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
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
      #result[:permissions].should == [{:security=>"dangerous", :group=>"Your location", :description=>"fine (GPS) location", :description_full=>"Access fine location sources such as the Global Positioning System on the tablet, where available. Malicious apps may use this to determine where you are, and may consume additional battery power. Access fine location sources such as the Global Positioning System on the phone, where available. Malicious apps may use this to determine where you are, and may consume additional battery power."}, {:security=>"dangerous", :group=>"Network communication", :description=>"full Internet access", :description_full=>"Allows the app to create network sockets."}, {:security=>"safe", :group=>"Network communication", :description=>"view network state", :description_full=>"Allows the app to view the state of all networks."}]
      # Stubbing out for now, can't find them in the redesigned page.
      result[:permissions].should == []
      result[:rating_distribution].should == {5=>26367, 4=>11216, 3=>2613, 2=>1455, 1=>2460}
      result[:html].should == test_src_data3
    end

    it 'should populate the associated apps keys' do
      result = App.parse(test_src_data2)

      result[:related].should be_a(Array)
      result[:users_also_installed].should be_a(Array)
      result[:more_from_developer].should be_a(Array)

      result[:related].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:users_also_installed].first[:app_id].should == 'com.socialnmobile.dictapps.notepad.color.note'
      result[:more_from_developer].first[:app_id].should == 'com.evernote.wear'
    end

    it 'should populate the reviews' do
      result = App.parse(test_src_data4)
      result[:reviews].should be_a(Array)
      result[:reviews].size == 9
      result[:reviews][2][:author_name].should == 'sidi Gueye'
      result[:reviews][2][:review_title].should  == 'Trop cool'
      result[:reviews][2][:review_text].should  == "J'ai vraiment adoré l'appli c trop cool !!"
      result[:reviews][2][:review_score].should  == 5
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
