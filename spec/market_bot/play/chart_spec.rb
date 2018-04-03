require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe MarketBot::Play::Chart do
  shared_context('parsing a chart') do
    it 'should have entries with a valid length' do
      expect(@parsed.length).to be > 1
    end

    it 'should have entries with valid attribute keys' do
      expect(@parsed).to all(have_key(:package)).and all(have_key(:rank)).and \
        all(have_key(:title)).and all(have_key(:store_url)).and \
          all(have_key(:developer)).and all(have_key(:icon_url))
    end

    it 'should have entries with valid packages' do
      @parsed.each_with_index do |v, i|
        msg = "i=#{i}, v=#{v.inspect}"
        expect(v[:package]).to be_kind_of(String), msg
        expect(v[:package]).to match(/[a-zA-Z0-9]+/), msg
      end
    end

    it 'should have entries with valid ranks' do
      @parsed.each_with_index do |v, i|
        msg = "i=#{i}, v=#{v.inspect}"
        expect(v[:rank]).to be_kind_of(expected_number_class).and(be > 0), msg
      end

      ranks = @parsed.map { |e| e[:rank] }
      expect(ranks).to eq((ranks[0]..ranks[-1]).to_a)
    end

    it 'should have entries with valid titles' do
      @parsed.each_with_index do |v, i|
        msg = "i=#{i}, v=#{v.inspect}"
        expect(v[:title]).to be_kind_of(String), msg
        expect(v[:title].length).to (be > 1), msg
      end
    end

    it 'should have entries with valid store_urls' do
      @parsed.each_with_index do |v, i|
        msg = "i=#{i}, v=#{v.inspect}"
        expect(v[:store_url]).to be_kind_of(String), msg
        expect(v[:store_url]).to match(/\Ahttps:\/\/play.google.com\/store\/apps\/details\?id=.+&hl=en\z/), msg
      end
    end

    it 'should have entries with valid developers' do
      @parsed.each_with_index do |v, i|
        msg = "i=#{i}, v=#{v.inspect}"
        expect(v[:developer]).to be_kind_of(String), msg
        expect(v[:developer].length).to (be > 1), msg
      end
    end

    it 'should have entries with valid icon_urls' do
      @parsed.each_with_index do |v, i|
        msg = "i=#{i}, v=#{v.inspect}"
        expect(v[:icon_url]).to be_kind_of(String), msg
        expect(v[:icon_url]).to match(/\Ahttps:\/\/.+\z/), msg
      end
    end
  end

  describe '(topselling_paid - GAME_ARCADE)' do
    include_context 'parsing a chart'

    before(:all) do
      @collection = 'topselling_paid'
      @category = 'GAME_ARCADE'
      @html = read_play_data('chart-topselling_paid-GAME_ARCADE-0.txt')
      @parsed = MarketBot::Play::Chart.parse(@html)
    end
  end

  it 'should generate store_urls' do
    collection = 'topselling_paid'
    category = 'GAME_ARCADE'
    chart = MarketBot::Play::Chart.new(collection, category, max_pages: 2)

    expect(chart.store_urls.length).to eq(2)

    chart.store_urls.each_with_index do |url, i|
      msg = "i=#{i}, url=#{url}"
      pattern = /\Ahttps:\/\/play\.google\.com\/store\/apps\/category\/#{category}\/collection\/#{collection}\?start=#{i * 100}&gl=us&num=100&hl=en\z/
      expect(url).to match(Regexp.new(pattern)), msg
    end
  end

  it 'should update (default)' do
    collection = 'topselling_paid'
    category = 'GAME_ARCADE'
    chart = MarketBot::Play::Chart.new(collection, category, max_pages: 7)
    code = 200

    chart.store_urls.each_with_index do |url, i|
      html = read_play_data("chart-topselling_paid-GAME_ARCADE-#{i}.txt")
      response = Typhoeus::Response.new(code: code, headers: '', body: html)
      Typhoeus.stub(url).and_return(response)
    end

    chart.update

    ranks = chart.result.map { |e| e[:rank] }
    expect(ranks).to eq((ranks[0]..ranks[-1]).to_a)
  end

  it 'should update (jp ja)' do
    collection = 'topselling_paid'
    category = 'BUSINESSS'
    chart = MarketBot::Play::Chart.new(collection, category, max_pages: 7, country: 'jp', lang: 'ja')
    code = 200

    chart.store_urls.each_with_index do |url, i|
      html = read_play_data("chart-jp-ja-topselling_paid-BUSINESS-#{i}.txt")
      response = Typhoeus::Response.new(code: code, headers: '', body: html)
      Typhoeus.stub(url).and_return(response)
    end

    chart.update

    ranks = chart.result.map { |e| e[:rank] }
    expect(ranks).to eq((ranks[0]..ranks[-1]).to_a)
  end

  it 'should raise a ResponseError for unknown http codes' do
    collection = 'topselling_paid'
    category = 'GAME_ARCADE'
    chart = MarketBot::Play::Chart.new(collection, category)
    code = 0
    html = ''

    chart.store_urls.each_with_index do |url, _i|
      response = Typhoeus::Response.new(code: code, headers: '', body: html)
      Typhoeus.stub(url).and_return(response)
    end

    expect do
      chart.update
    end.to raise_error(MarketBot::ResponseError)
  end
end
