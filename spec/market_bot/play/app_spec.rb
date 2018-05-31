require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe MarketBot::Play::App do
  shared_context('parsing an app') do
    it 'should parse the category attribute' do
      expect(@parsed[:category]).to eq('Arcade').or eq('Weather').or eq('Simulation')
    end

    it 'should parse the category_url attribute' do
      expect(@parsed[:category_url]).to eq('GAME_ARCADE').or eq('WEATHER').or eq('GAME_SIMULATION')
    end

    it 'should parse the categories attribute' do
      expect(@parsed[:categories]).to eq(['Arcade']).or eq(['Weather']).or eq(['Simulation', 'Pretend Play'])
    end

    it 'should parse the categories_urls attribute' do
      expect(@parsed[:categories_urls]).to eq(['GAME_ARCADE']).or eq(['WEATHER']).or eq(%w[GAME_SIMULATION FAMILY_PRETEND])
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

    it 'should parse the html attribute' do
      expect(@parsed[:html]).to eq(@html)
    end

    it 'should parse the installs attribute' do
      expect(@parsed[:installs]).to match(/\A\d+,*.*\+\z/)
    end

    it 'should parse the more_from_developer attribute' do
      expect(@parsed[:more_from_developer]).to eq(nil).or be_kind_of(Array)
    end

    it 'should parse the more_from_developer attribute' do
      if @parsed[:more_from_developer]
        @parsed[:more_from_developer].each do |v|
          expect(v).to be_kind_of(Hash)
          expect(v).to have_key(:package)
          expect(v[:package]).to match(/[a-zA-Z0-9]+/)
        end
      end
    end

    it 'should parse the price attribute' do
      expect(@parsed[:price]).to eq('0').or match(/\A\$\d+\.\d\d\z/)
    end

    it 'should parse the rating attribute' do
      expect(@parsed[:rating]).to be_kind_of(String).and match(/\A\d\.\d.+\z/)
    end

    it 'should parse the requires_android attribute' do
      expect(@parsed[:requires_android]).to \
        be_kind_of(String).and match(/\A\d(\.\d)* and up\z/)
    end

    it 'should parse the screenshot_urls attribute' do
      expect(@parsed[:screenshot_urls]).to be_kind_of(Array)
      expect(@parsed[:screenshot_urls].length).to be >= 0
    end

    it 'should parse the similar attribute' do
      expect(@parsed[:similar]).to eq(nil).or be_kind_of(Array)
    end

    it 'should parse the correct similar attribute' do
      if @parsed[:similar]
        expect(@parsed[:similar].length).to be >= 0
        expect(@parsed[:similar]).to all(be_kind_of(Hash)).and \
          all(have_key(:package))
      end
    end

    it 'should parse the size attribute' do
      expect(@parsed[:size]).to eq(nil).or(
        be_kind_of(String).and(match(/\A\d+\.?\d*M\z/))
      )
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
      expect(@parsed[:website_url]).not_to match(/privacy/)
    end

    it 'should parse the privacy_url attribute' do
      if @parsed[:privacy_url]
        expect(@parsed[:privacy_url]).to match(/\Ahttps?:\/\//).and \
          be_kind_of(String)
      end
    end

    it 'should parse the whats_new attribute' do
      expect(@parsed[:whats_new]).to be_kind_of(String).or \
        be_kind_of(NilClass)
    end

    it 'should parse the contains_ads attribute' do
      expect(@parsed[:contains_ads]).to eq(true).or \
        eq(false)
    end

    it 'should parse the in_app_products_price attribute' do
      expect(@parsed[:in_app_products_price]).to eq(nil).or(
        be_kind_of(String).and(match(/(.+(\d|.){1,}\ )\-(.+(\d|.){1,})\ per\ item/))
      )
    end

    it 'should parse the physical_address attribute' do
      expect(@parsed[:physical_address]).to eq(nil).or(
        be_kind_of(String)
      )
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

  context '(app-com.hasbro.mlpcoreAPPSTORE)' do
    include_context 'parsing an app'

    before(:all) do
      @package = 'com.hasbro.mlpcoreAPPSTORE'
      @html = read_play_data('app-com.hasbro.mlpcoreAPPSTORE.txt')
      @parsed = MarketBot::Play::App.parse(@html)
    end
  end

  it 'should populate the attribute getters' do
    package = 'app-com.mg.android'
    html = read_play_data('app-com.mg.android.txt')
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

    expect do
      app.update
    end.to raise_error(MarketBot::NotFoundError)
  end

  it 'should raise an UnavailableError for http code 403' do
    package = 'com.not.available.in.your.country.app'
    code = 403

    app = MarketBot::Play::App.new(package)
    response = Typhoeus::Response.new(code: code)
    Typhoeus.stub(app.store_url).and_return(response)

    expect do
      app.update
    end.to raise_error(MarketBot::UnavailableError)
  end

  it 'should raise a ResponseError for unknown http codes' do
    package = 'com.my.internet.may.be.dead'
    code = 0

    app = MarketBot::Play::App.new(package)
    response = Typhoeus::Response.new(code: code)
    Typhoeus.stub(app.store_url).and_return(response)

    expect do
      app.update
    end.to raise_error(MarketBot::ResponseError)
  end
end
