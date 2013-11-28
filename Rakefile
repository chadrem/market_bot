require 'bundler/gem_tasks'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

desc 'Start an IRB console with Workers loaded'
task :console do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require 'market_bot'
  require 'irb'

  ARGV.clear

  IRB.start
end

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

      download('https://play.google.com/store/apps/details?id=com.mg.android',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'app_3.txt'))

      download('https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?num=24',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page1.txt'))

      download('https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=24&num=24',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page2.txt'))

      download('https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=48&num=24',
               File.join(File.dirname(__FILE__), 'spec', 'market_bot', 'android', 'data', 'leaderboard-apps_topselling_paid-page3.txt'))

      download('https://play.google.com/store/apps/category/ARCADE/collection/topselling_paid?start=96&num=24',
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
