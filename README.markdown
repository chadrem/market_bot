# Market Bot - Ruby scraper for Google Play (Android Market)

Market Bot is a high performance Ruby scraper for Google's Android Market with a simple to use API.
Currently it supports scraping apps, leaderboards, and app searches.
Books, music, movies, etc aren't currently supported.
It is built on top of Nokogiri and Typhoeus.
Used in production to power [www.droidmeter.com](http://www.droidmeter.com/?t=github).

## Dependencies

* Nokogiri
* Typhoeus

## Installation

    gem install market_bot

## Simple API Examples

    require 'rubygems'
    require 'market_bot'

    # Download/parse the leaderboard.
    lb = MarketBot::Android::Leaderboard.new(:topselling_free, :game)
    lb.update

    # Download/parse the details for the first and last entries of the leaderboard.
    first_app = MarketBot::Android::App.new(lb.results.first[:market_id])
    last_app = MarketBot::Android::App.new(lb.results.last[:market_id])
    first_app.update
    last_app.update
    puts "First place app (#{first_app.title}) price: #{first_app.price}"
    puts "Last place app (#{last_app.title}) price: #{last_app.price}"

    # Search for apps.
    sq = MarketBot::Android::SearchQuery.new('donkeys')
    sq.update
    puts "Results found: #{sq.results.count}"

    # Download/parse developer pages.
    developer = MarketBot::Android::Developer.new('Zynga')
    developer.update
    puts "Results found: #{developer.results.count}"

## Advanced API Examples

    require 'rubygems'
    require 'market_bot'

    # Create a reusable hydra object with 5 http workers.
    hydra = Typhoeus::Hydra.new(:max_concurrency => 5)

    # Download/parse the leaderboard.
    lb = MarketBot::Android::Leaderboard.new(:topselling_free, :game, :hyda => hydra)
    lb.update

    # Download/parse the details for the first and last entries of the leaderboard using the batch API.
    first_app = MarketBot::Android::App.new(lb.results.first[:market_id], :hydra => hydra)
    last_app = MarketBot::Android::App.new(lb.results.last[:market_id], :hydra => hydra)
    first_app.enqueue_update
    last_app.enqueue_update do |a|
      # Callback example.  This block will execute on a successful hydra.run.
      puts "Callback... title: #{a.title}"
    end
    hydra.run

    # You must manually check if an error occurred when using the batch API without callbacks.
    puts "First place app (#{first_app.title}) price: #{first_app.price}" unless first_app.error
    puts "Last place app (#{last_app.title}) price: #{last_app.price}" unless last_app.error

## Contributing to Market Bot

1. Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
2. Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
3. Fork the project.
4. Start a feature/bugfix branch.
5. Commit and push until you are happy with your contribution.
6. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
7. Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 - 2012 Chad Remesch. See LICENSE.txt for
further details.

