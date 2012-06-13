# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "market_bot"
  gem.homepage = "http://github.com/chadrem/market_bot"
  gem.license = "MIT"
  gem.summary = %Q{Market Bot: High performance Ruby scraper for Google's Android Market}
  gem.description = %Q{Market Bot is a high performance Ruby scraper for Google's Android Market with a simple to use API.  It is built on top of Nokogiri and Typhoeus.}
  gem.email = "chad@remesch.com"
  gem.authors = ["Chad Remesch"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "market_bot #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'typhoeus'

namespace :spec do
  namespace :data do
    def download(url, save_path)
      resp = Typhoeus::Request.get(url)
      File.open(save_path, "w") do |file|
        resp.body.force_encoding('utf-8')
        file.puts(resp.body)
      end
    end

    desc 'download the latest test data used by the specs'
    task :update do
      download('https://play.google.com/store/apps/details?id=com.bluefroggaming.popdat',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'app_1.txt'))

      download('https://play.google.com/store/apps/details?id=com.evernote',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'app_2.txt'))

      download('https://play.google.com/store/apps/details?id=kooistar.solutions.Thermometer',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'app_3.txt'))

      download('https://play.google.com/store/apps/collection/topselling_paid',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page1.txt'))

      download('https://play.google.com/store/apps/collection/topselling_paid?start=24&amp;num=24',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page2.txt'))

      download('https://play.google.com/store/apps/collection/topselling_paid?start=48&amp;num=24',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page3.txt'))

      download('https://play.google.com/store/apps/collection/topselling_paid?start=456&num=24',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page4.txt'))

      download('https://play.google.com/store/apps/collection/editors_choice',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_editors_choice.txt'))
    end
  end
end

namespace :benchmark do
  task :android do
    require 'market_bot'
    require 'benchmark'

    hydra = Typhoeus::Hydra.new(:max_concurrency => 20)

    leaderboard = nil
    leaderboard_ms = Benchmark.realtime {
      leaderboard = MarketBot::Android::Leaderboard.new(:apps_topselling_paid, nil, :hydra => hydra)
      leaderboard.update
    }

    puts '----------------------------------------------------'
    puts 'Benchmark Leaderboard: Top Selling Paid Apps'
    puts '----------------------------------------------------'
    puts "app count: #{leaderboard.results.length}"
    puts "time: #{leaderboard_ms.round(3)} seconds"
    puts

    apps = nil
    apps_ms = Benchmark.realtime {
      apps = leaderboard.results.map{ |r| MarketBot::Android::App.new(r[:market_id], :hydra => hydra).enqueue_update }
      hydra.run
    }

    puts '----------------------------------------------------'
    puts 'Benchmark Apps: top Selling Paid Apps'
    puts '----------------------------------------------------'
    puts "app count: #{apps.length}"
    puts "time: #{apps_ms.round(3)} seconds"
  end
end
