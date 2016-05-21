require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe MarketBot::Play::App do
  shared_context('parsing an app') do
    it 'category attribute' do
      expect(@parsed[:category]).to eq('Arcade').or eq('Weather')
    end

    it 'category_url attribute' do
      expect(@parsed[:category_url]).to eq('GAME_ARCADE').or eq('WEATHER')
    end

    it 'content_rating attribute' do
      expect(@parsed[:content_rating]).to eq('Unrated').or eq('Everyone')
    end

    it 'cover_image_url attribute' do
      expect(@parsed[:cover_image_url]).to match(/\Ahttps:\/\//)
    end

    it 'current_version attribute' do
      expect(@parsed[:current_version]).to be_kind_of(String)
      expect(@parsed[:current_version].length).to be > 0
      expect(@parsed[:current_version]).to match(/\A\d/).and match(/\d\z/)
    end

    it 'description attribute' do
      expect(@parsed[:description]).to be_kind_of(String)
      expect(@parsed[:description].length).to be > 10
    end

    it 'developer attribute' do
      expect(@parsed[:developer]).to be_kind_of(String)
      expect(@parsed[:developer].length).to be > 5
    end

    it 'email attribute' do
      expect(@parsed[:email]).to \
        match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    end

    it 'full_screenshot_urls attribute' do
      @parsed[:full_screenshot_urls].each do |url|
        expect(url).to match(/\Ahttps:\/\//)
      end
    end

    it 'html attribute' do
      expect(@parsed[:html]).to eq(@html)
    end

    it 'installs attribute' do
      expect(@parsed[:installs]).to match(/\A\d+,*.* - .*,*\d+\z/)
    end

    it 'more_from_developer attribute' do
      @parsed[:more_from_developer].each do |v|
        expect(v).to be_kind_of(Hash)
        expect(v).to have_key(:package)
        expect(v[:package]).to match(/[a-zA-Z0-9]+/)
      end
    end

    it 'price attribute' do
      expect(@parsed[:price]).to eq('0').or match(/\A\$\d+\.\d\d\z/)
    end

    it 'rating attribute' do
      expect(@parsed[:rating]).to be_kind_of(String).and match(/\A\d\.\d\z/)
    end

    it 'rating_distribution attribute' do
      expect(@parsed[:rating_distribution].length).to eq(5)
      expect(@parsed[:rating_distribution].keys).to \
        all(be_kind_of(Fixnum)).and contain_exactly(1, 2, 3, 4, 5)
      expect(@parsed[:rating_distribution].values).to \
        all(be_kind_of(Fixnum)).and all(be_kind_of(Fixnum)).and all(be >= 0)
    end

    it 'requires_android attribute' do
      expect(@parsed[:requires_android]).to \
        be_kind_of(String).and match(/\A\d\.\d and up\z/)
    end

    it 'reviews attribute' do
      expect(@parsed[:reviews].length).to be > 0
      expect(@parsed[:reviews]).to \
        be_kind_of(Array).and all(be_kind_of(Hash)).and \
        all(have_key(:title)).and all(have_key(:score)).and \
        all(have_key(:text))
    end

    it 'screenshot_urls attribute' do
      expect(@parsed[:screenshot_urls]).to all(match(/\Ahttps:\/\//))
    end

    it 'similar attribute' do
      expect(@parsed[:similar].length).to be > 0
      expect(@parsed[:similar]).to all(be_kind_of(Hash)).and \
        all(have_key(:package))
    end

    it 'size attribute' do
      expect(@parsed[:size]).to be_kind_of(String).and match(/\A\d+\.?\d*M\z/)
    end

    it 'title attribute' do
      expect(@parsed[:title]).to be_kind_of(String)
      expect(@parsed[:title].length).to be > 5
    end

    it 'updated attribute' do
      expect(@parsed[:updated]).to be_kind_of(String).and \
        match(/\A[A-Z][a-z]+ \d+, 20\d\d\z/)
    end

    it 'votes attribute' do
      expect(@parsed[:votes]).to be_kind_of(Fixnum).and be >= 0
    end

    it 'website_url attribute' do
      expect(@parsed[:website_url]).to be_kind_of(String).and \
        match(/\Ahttps?:\/\//)
    end
  end

  context "should parse the app-com.bluefroggaming.popdat" do
    include_context 'parsing an app'

    before(:all) do
      @package = 'app-com.bluefroggaming.popdat'
      @html = read_play_data('app-com.bluefroggaming.popdat.txt')
      @parsed = MarketBot::Play::App.parse(@html)
    end
  end

  context "should parse the app-com.mg.android" do
    include_context 'parsing an app'

    before(:all) do
      @package = 'app-com.mg.android',
      @html = read_play_data('app-com.mg.android.txt'),
      @parsed = MarketBot::Play::App.parse(@html)
    end
  end
end
