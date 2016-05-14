require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

test_id = :topselling_paid
test_category = :arcade

def stub_hydra(hydra)
  test_src_pages = []
  (1..4).each do |page|
    test_src_pages[page] = read_file(File.dirname(__FILE__), 'data', "chart-apps_topselling_paid-page#{page}.txt")
  end

  (0...4).each do |i|
    start = i * 24
    response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_pages[i + 1])
    url = "https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=#{start}&gl=us&num=24&hl=en"
    Typhoeus.stub(url).and_return(response)
  end

  test_src_editors_choice = read_file(File.dirname(__FILE__), 'data', "chart-apps_editors_choice.txt")

  response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_editors_choice)
  url = "https://play.google.com/store/apps/collection/editors_choice?&hl=en"
  Typhoeus.stub(url).and_return(response)
end

def check_results(results)
  it 'should return valid results' do
    expect(results.length).to eq(96)
    results.each do |app|
      expect(app.keys.sort).to eq([:developer, :icon_url, :market_id, :market_url, :price_usd, :stars, :title])
      expect(app[:market_url]).to eq(App.new(app[:market_id]).market_url)
      expect(app[:price_usd]).to match(/^\$\d+\.\d{2}$/)
      expect(app[:stars].to_f).to be > 0.0
      expect(app[:stars].to_f).to be <= 5.0
    end
  end

  it 'should have the top ranking app with valid details' do
    expect(results.first[:developer]).to eq('Mojang')
    expect(results.first[:market_id]).to eq('com.mojang.minecraftpe')
    expect(results.first[:market_url]).to eq('https://play.google.com/store/apps/details?id=com.mojang.minecraftpe&hl=en')
    expect(results.first[:price_usd]).to eq('$6.99')
    expect(results.first[:stars]).to eq('4.5')
    expect(results.first[:title]).to eq("Minecraft: Pocket Edition")
  end

end

describe 'Chart' do
  context 'Construction' do
    it 'should copy params' do
      chart =MarketBot::Play::Chart.new(test_id, test_category)
      expect(chart.identifier).to eq(test_id)
      expect(chart.category).to eq(test_category)
    end

    it 'should copy optional params' do
      hydra = Typhoeus::Hydra.new
      chart = MarketBot::Play::Chart.new(test_id, test_category, :hydra => hydra)
      expect(chart.hydra).to equal(hydra)
    end

    it 'should have an optional category parameter' do
      chart = MarketBot::Play::Chart.new(test_id)
      expect(chart.identifier).to eq(test_id)
      expect(chart.category).to eq(nil)
    end
  end

  it 'should generate URLs using min and max page ranges' do
    chart = MarketBot::Play::Chart.new(test_id, test_category)
    urls = chart.market_urls(:min_page => 1, :max_page => 3)
    expect(urls).to eq([
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=0&gl=us&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=24&gl=us&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=48&gl=us&num=24&hl=en'
    ])
  end

  it 'should generate URLs using country' do
    chart = MarketBot::Play::Chart.new(test_id, test_category)
    urls = chart.market_urls(:min_page => 1, :max_page => 3, :country => 'au')
    expect(urls).to eq([
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=0&gl=au&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=24&gl=au&num=24&hl=en',
      'https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=48&gl=au&num=24&hl=en'
    ])
  end


  it 'should convert ranks to market chart pages (24 apps per page)' do
    app = MarketBot::Play::Chart.new(test_id, test_category)
    expect(app.rank_to_page(1)).to eq(1)
    expect(app.rank_to_page(24)).to eq(1)
    expect(app.rank_to_page(25)).to eq(2)
    expect(app.rank_to_page(48)).to eq(2)
  end

  describe 'Updating' do
    context 'Quick API' do
      stub_hydra(Typhoeus::Hydra.hydra)
      chart = MarketBot::Play::Chart.new(test_id, test_category)
      chart.instance_variable_set('@hydra', Typhoeus::Hydra.hydra)
      chart.update(:min_rank => 1, :max_rank => 96)

      check_results(chart.results)
    end

    context 'Batch API' do
      hydra = Typhoeus::Hydra.new
      stub_hydra(hydra)
      chart = MarketBot::Play::Chart.new(test_id, test_category, :hydra => hydra)
      chart.enqueue_update(:min_rank => 1, :max_rank => 96)
      hydra.run

      check_results(chart.results)
    end

    context 'special case (editors choice page)' do
      it 'should properly parse the page and turn them into results' do
        hydra = Typhoeus::Hydra.new
        stub_hydra(hydra)
        chart = MarketBot::Play::Chart.new('editors_choice', nil, :hydra => hydra)
        chart.update

        expect(chart.results.count).to eq(60)

        app = chart.results.last

        expect(app[:title]).to eq("Instacart: Grocery Delivery")
        expect(app[:price_usd]).to eq("Free")
        expect(app[:developer]).to eq("Instacart")
        expect(app[:market_id]).to eq("com.instacart.client")
        expect(app[:market_url]).to eq("https://play.google.com/store/apps/details?id=com.instacart.client&hl=en")
      end
    end
  end
end
