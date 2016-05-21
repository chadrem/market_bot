require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

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

  describe "(zynga)" do
    include_context 'parsing a developer'

    before(:all) do
      @name = 'zynga'
      @html = read_play_data('developer-zynga.txt')
      @parsed = MarketBot::Play::Chart.parse(@html)
    end
  end
end
