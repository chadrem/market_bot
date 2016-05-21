require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

describe MarketBot::Play::Chart do
  shared_context('parsing a chart') do
    it 'should be a valid length' do
      expect(@parsed.length).to be > 1
    end

    it 'should have attributes' do
      expect(@parsed).to all(have_key(:package)).and all(have_key(:rank)).and \
        all(have_key(:title)).and all(have_key(:store_url)).and \
        all(have_key(:developer)).and all(have_key(:icon_url))
    end
  end

  describe "(topselling_paid - GAME_ARCADE)" do
    include_context 'parsing a chart'

    before(:all) do
      @collection = 'topselling_paid'
      @category ='GAME_ARCADE'
      @html = read_play_data('chart-topselling_paid-GAME_ARCADE-0.txt')
      @parsed = MarketBot::Play::Chart.parse(@html)
    end
  end
end
