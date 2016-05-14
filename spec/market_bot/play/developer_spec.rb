require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

include MarketBot::Play

test_developer_id = 'Zynga'

def stub_hydra(hydra)
  test_src_pages = []
  test_src_pages[0] = read_file(File.dirname(__FILE__), 'data', "developer-zynga.txt")

  response = Typhoeus::Response.new(:code => 200, :headers => '', :body => test_src_pages[0])
  url = "https://play.google.com/store/apps/developer?id=Zynga&gl=us&hl=en"
  Typhoeus.stub(url).and_return(response)
end

def check_results(results)
  it 'should return valid results' do
    results.length.should == 24
    results[0][:title].should == 'Words With Friends – Play Free'
  end
end

describe 'developer' do
  context 'Construction' do
    it 'should copy params' do
      dev = Developer.new(test_developer_id)
      dev.identifier.should == test_developer_id
    end

    it 'should copy optional params' do
      hydra = Typhoeus::Hydra.new
      dev = Developer.new(test_developer_id, :hydra => hydra)
      dev.hydra.should equal(hydra)
    end
  end

  describe 'Updating' do
    context 'Quick API' do
      stub_hydra(Typhoeus::Hydra.hydra)
      dev = Developer.new(test_developer_id)
      dev.instance_variable_set('@hydra', Typhoeus::Hydra.hydra)
      dev.update

      check_results(dev.results)
    end

    context 'Batch API' do
      hydra = Typhoeus::Hydra.new
      stub_hydra(hydra)
      dev = Developer.new(test_developer_id, :hydra => hydra)
      dev.enqueue_update
      hydra.run

      check_results(dev.results)
    end
  end
end
