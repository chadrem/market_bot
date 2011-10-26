require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Android

test_id = :apps_topselling_paid
test_category = :arcade


def stub_hydra(hydra)
  test_src_pages = []
  (1..4).each do |page|
    test_src_pages[page] = read_file(File.dirname(__FILE__), 'data', "leaderboard-apps_topselling_paid-page#{page}.txt")
  end

  (0...4).each do |i|
    start = i * 24
    response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_pages[i + 1])
    url = "https://market.android.com/details?id=apps_topselling_paid&cat=ARCADE&start=#{start}&num=24"
    hydra.stub(:get, url).and_return(response)
  end

  test_src_editors_choice = read_file(File.dirname(__FILE__), 'data', "leaderboard-apps_editors_choice.txt")

  response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_editors_choice)
  url = "https://market.android.com/details?id=apps_editors_choice"
  hydra.stub(:get, url).and_return(response)
end

def check_results(results)
  it 'should return valid results' do
    results.length.should == 72
    results.each do |app|
      app.keys.sort.should == [:developer, :market_id, :market_url, :price_usd, :stars, :title]
      app[:market_url].should == App.new(app[:market_id]).market_url
      app[:price_usd].should =~ /^\$\d+\.\d{2}$/
      app[:stars].to_f.should > 0.0
      app[:stars].to_f.should <= 5.0
    end
  end

  it 'should have Cut The Rope as the top ranking app with valid details' do
    results.first[:developer].should == 'ZeptoLab'
    results.first[:market_id].should == 'com.zeptolab.ctr.paid'
    results.first[:market_url].should == 'https://market.android.com/details?id=com.zeptolab.ctr.paid'
    results.first[:price_usd].should == '$0.99'
    results.first[:stars].should == '4.6'
    results.first[:title].should == 'Cut the Rope'
  end

end

describe 'Leaderboard' do
  context 'Construction' do
    it 'should copy params' do
      lb = Leaderboard.new(test_id, test_category)
      lb.identifier.should == test_id
      lb.category.should == test_category
    end

    it 'should copy optional params' do
      hydra = Typhoeus::Hydra.new
      lb = Leaderboard.new(test_id, test_category, :hydra => hydra)
      lb.hydra.should equal(hydra)
    end

    it 'should have an optional category parameter' do
      lb = Leaderboard.new(test_id)
      lb.identifier.should == test_id
      lb.category.should == nil
    end
  end

  it 'should generate URLs using min and max page ranges' do
    lb = Leaderboard.new(test_id, test_category)
    urls = lb.market_urls(:min_page => 1, :max_page => 3)
    urls.should == [
      'https://market.android.com/details?id=apps_topselling_paid&cat=ARCADE&start=0&num=24',
      'https://market.android.com/details?id=apps_topselling_paid&cat=ARCADE&start=24&num=24',
      'https://market.android.com/details?id=apps_topselling_paid&cat=ARCADE&start=48&num=24'
    ]
  end

  it 'should convert ranks to market leaderboard pages (24 apps per page)' do
    app = Leaderboard.new(test_id, test_category)
    app.rank_to_page(1).should == 1
    app.rank_to_page(24).should == 1
    app.rank_to_page(25).should == 2
    app.rank_to_page(48).should == 2
  end

  describe 'Updating' do
    context 'Quick API' do
      stub_hydra(Typhoeus::Hydra.hydra)
      lb = Leaderboard.new(test_id, test_category)
      lb.update(:min_rank => 1, :max_rank => 96)

      check_results(lb.results)
    end

    context 'Batch API' do
      hydra = Typhoeus::Hydra.new
      stub_hydra(hydra)
      lb = Leaderboard.new(test_id, test_category, :hydra => hydra)
      lb.enqueue_update(:min_rank => 1, :max_rank => 96)
      hydra.run

      check_results(lb.results)
    end

    context 'special case (editors choice page)' do
      it 'should properly parse the page and turn them into results' do
        hydra = Typhoeus::Hydra.new
        stub_hydra(hydra)
        lb = Leaderboard.new('apps_editors_choice', nil, :hydra => hydra)
        lb.update

        lb.results.count.should == 37

        app = lb.results.last

        app[:title].should == 'WorldMate '
        app[:price_usd].should == nil
        app[:developer].should == 'WorldMate'
        app[:market_id].should == 'com.worldmate'
        app[:market_url].should == 'https://market.android.com/details?id=com.worldmate'
      end
    end
  end
end
