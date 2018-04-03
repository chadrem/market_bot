require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe MarketBot::Play::Developer do
  shared_context('parsing a developer') do
    it 'should be a valid length' do
      expect(@parsed.length).to be > 1
    end

    it 'should have attributes' do
      expect(@parsed).to all(have_key(:package)).and \
        all(have_key(:title)).and all(have_key(:store_url)).and \
          all(have_key(:developer)).and all(have_key(:icon_url))
    end
  end

  describe '(zynga)' do
    include_context 'parsing a developer'

    before(:all) do
      @name = 'zynga'
      @html = read_play_data('developer-zynga.txt')
      @parsed = MarketBot::Play::Chart.parse(@html)
    end
  end

  it 'should generate store_urls' do
    name = 'zynga'
    dev = MarketBot::Play::Developer.new(name)

    expect(dev.store_urls.length).to eq(1)

    dev.store_urls.each_with_index do |url, i|
      msg = "i=#{i}, url=#{url}"
      pattern = /\Ahttps:\/\/play\.google\.com\/store\/apps\/developer\?id=zynga&start=0&gl=us&num=100&hl=en\z/
      expect(url).to match(Regexp.new(pattern)), msg
    end
  end

  it 'should update' do
    name = 'zynga'
    dev = MarketBot::Play::Developer.new(name)
    code = 200

    dev.store_urls.each_with_index do |url, _i|
      html = read_play_data('developer-zynga.txt')
      response = Typhoeus::Response.new(code: code, headers: '', body: html)
      Typhoeus.stub(url).and_return(response)
    end

    dev.update
  end
end
