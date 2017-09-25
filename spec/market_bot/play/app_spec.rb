require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe MarketBot::Play::App do
  shared_context('parsing an app') do
    it 'should parse the category attribute' do
      expect(@parsed[:category]).to eq('Arcade').or eq('Weather')
    end

    it 'should parse the category_url attribute' do
      expect(@parsed[:category_url]).to eq('GAME_ARCADE').or eq('WEATHER')
    end

    it 'should parse the content_rating attribute' do
      expect(@parsed[:content_rating]).to eq('Unrated').or eq('Everyone')
    end

    it 'should parse the cover_image_url attribute' do
      expect(@parsed[:cover_image_url]).to match(/\Ahttps:\/\//)
    end

    it 'should parse the current_version attribute' do
      expect(@parsed[:current_version]).to be_kind_of(String)
      expect(@parsed[:current_version].length).to be > 0
      expect(@parsed[:current_version]).to match(/\A\d/).and match(/\d\z/)
    end

    it 'should parse the description attribute' do
      expect(@parsed[:description]).to be_kind_of(String)
      expect(@parsed[:description].length).to be > 10
    end

    it 'should parse the developer attribute' do
      expect(@parsed[:developer]).to be_kind_of(String)
      expect(@parsed[:developer].length).to be > 5
    end

    it 'should parse the developer_id attribute' do
      expect(@parsed[:developer_id]).to be_kind_of(String)
    end

    it 'should parse the email attribute' do
      expect(@parsed[:email]).to \
        match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    end

    it 'should parse the full_screenshot_urls attribute' do
      @parsed[:full_screenshot_urls].each do |url|
        expect(url).to match(/\Ahttps:\/\//)
      end
    end

    it 'should parse the html attribute' do
      expect(@parsed[:html]).to eq(@html)
    end

    it 'should parse the installs attribute' do
      expect(@parsed[:installs]).to match(/\A\d+,*.* - .*,*\d+\z/)
    end

    it 'should parse the more_from_developer attribute' do
      @parsed[:more_from_developer].each do |v|
        expect(v).to be_kind_of(Hash)
        expect(v).to have_key(:package)
        expect(v[:package]).to match(/[a-zA-Z0-9]+/)
      end
    end

    it 'should parse the price attribute' do
      expect(@parsed[:price]).to eq('0').or match(/\A\$\d+\.\d\d\z/)
    end

    it 'should parse the rating attribute' do
      expect(@parsed[:rating]).to be_kind_of(String).and match(/\A\d\.\d\z/)
    end

    it 'should parse the rating_distribution attribute' do
      expect(@parsed[:rating_distribution].length).to eq(5)
      expect(@parsed[:rating_distribution].keys).to \
        all(be_kind_of(expected_number_class)).and contain_exactly(1, 2, 3, 4, 5)
      expect(@parsed[:rating_distribution].values).to \
        all(be_kind_of(expected_number_class)).and all(be_kind_of(expected_number_class)).and all(be >= 0)
    end

    it 'should parse the requires_android attribute' do
      expect(@parsed[:requires_android]).to \
        be_kind_of(String).and match(/\A\d\.\d and up\z/)
    end

    it 'should parse the reviews attribute' do
      expect(@parsed[:reviews].length).to be > 0
      expect(@parsed[:reviews]).to \
        be_kind_of(Array).and all(be_kind_of(Hash)).and \
        all(have_key(:title)).and all(have_key(:score)).and \
        all(have_key(:text)).and all(have_key(:review_id))
    end

    it 'should parse the screenshot_urls attribute' do
      expect(@parsed[:screenshot_urls]).to all(match(/\Ahttps:\/\//))
    end

    it 'should parse the similar attribute' do
      expect(@parsed[:similar].length).to be > 0
      expect(@parsed[:similar]).to all(be_kind_of(Hash)).and \
        all(have_key(:package))
    end

    it 'should parse the size attribute' do
      expect(@parsed[:size]).to eq(nil).or(
        be_kind_of(String).and match(/\A\d+\.?\d*M\z/))
    end

    it 'should parse the title attribute' do
      expect(@parsed[:title]).to be_kind_of(String)
      expect(@parsed[:title].length).to be > 5
    end

    it 'should parse the updated attribute' do
      expect(@parsed[:updated]).to be_kind_of(String).and \
        match(/\A[A-Z][a-z]+ \d+, 20\d\d\z/)
    end

    it 'should parse the votes attribute' do
      expect(@parsed[:votes]).to be_kind_of(expected_number_class).and be >= 0
    end

    it 'should parse the website_url attribute' do
      expect(@parsed[:website_url]).to be_kind_of(String).and \
        match(/\Ahttps?:\/\//)
    end

    it 'shoud parse the whats_new attribute' do
      expect(@parsed[:whats_new]).to be_kind_of(String).or \
        be_kind_of(NilClass)
    end
  end

  context '(app-com.bluefroggaming.popdat)' do
    include_context 'parsing an app'

    before(:all) do
      @package = 'com.bluefroggaming.popdat'
      @html = read_play_data('app-com.bluefroggaming.popdat.txt')
      @parsed = MarketBot::Play::App.parse(@html)
    end
  end

  context '(app-com.mg.android)' do
    include_context 'parsing an app'

    before(:all) do
      @package = 'com.mg.android'
      @html = read_play_data('app-com.mg.android.txt')
      @parsed = MarketBot::Play::App.parse(@html)
    end
  end

  it 'should populate the attribute getters' do
    package = 'app-com.bluefroggaming.popdat'
    html = read_play_data('app-com.bluefroggaming.popdat.txt')
    code = 200

    app = MarketBot::Play::App.new(package)
    response = Typhoeus::Response.new(code: code, headers: '', body: html)
    Typhoeus.stub(app.store_url).and_return(response)
    app.update

    MarketBot::Play::App::ATTRIBUTES.each do |a|
      expect(app.send(a)).to eq(app.result[a]), "Attribute: #{a}"
    end
  end

  it 'should raise a NotFoundError for http code 404' do
    package = 'com.missing.app'
    code = 404

    app = MarketBot::Play::App.new(package)
    response = Typhoeus::Response.new(code: code)
    Typhoeus.stub(app.store_url).and_return(response)

    expect {
      app.update
    }.to raise_error(MarketBot::NotFoundError)
  end

  it 'should raise an UnavailableError for http code 403' do
    package = 'com.not.available.in.your.country.app'
    code = 403

    app = MarketBot::Play::App.new(package)
    response = Typhoeus::Response.new(code: code)
    Typhoeus.stub(app.store_url).and_return(response)

    expect {
      app.update
    }.to raise_error(MarketBot::UnavailableError)
  end

  it 'should raise a ResponseError for unknown http codes' do
    package = 'com.my.internet.may.be.dead'
    code = 0

    app = MarketBot::Play::App.new(package)
    response = Typhoeus::Response.new(code: code)
    Typhoeus.stub(app.store_url).and_return(response)

    expect {
      app.update
    }.to raise_error(MarketBot::ResponseError)
  end
end
