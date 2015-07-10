# Market Bot - [![Build Status](https://travis-ci.org/chadrem/market_bot.svg?branch=master)](https://travis-ci.org/chadrem/market_bot) [![Coverage Status](https://coveralls.io/repos/chadrem/market_bot/badge.svg?branch=master&service=github)](https://coveralls.io/github/chadrem/market_bot?branch=master)

Market Bot is a high performance Ruby scraper for Google's Android Market with a simple to use API.
Currently it can: scrape apps, app leaderboards, movies, and tv shows.  It can also search for apps.
It is built on top of Nokogiri and Typhoeus.

**This project is currently seeking developers to help maintain it.
Please send pull requests or contact me if you are able to help out.
The best ways to get started are to fix bugs, improve documentation,
and merge useful changes from public forks.  By working together we
can make the best scraper for the Google Play Store!**

## Dependencies

* Nokogiri
* Typhoeus

## Installation

    gem install market_bot

## Getting Started Example

    require 'rubygems'
    require 'market_bot'

    # Download all the data for the Facebook app.
    app = MarketBot::Android::App.new('com.facebook.katana')
    app.update

    # Here we will print out the title of the app.
    puts app.title

    # Here we will print out the rating of the app.
    puts app.rating

    # And the price...
    puts app.price

    # market_bot has many other attributes for each app.
    # You can see what attributes are available in your version of
    # market_bot by printing a simple constant included in the gem.
    puts MarketBot::Android::App::MARKET_ATTRIBUTES.inspect

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

    # Print the rating for an app.
    puts MarketBot::Android::App.new('com.king.candycrushsaga').update.rating

    # Check if an app exists and has a title.
    def app_exists?(app_id)
      begin
        return !!MarketBot::Android::App.new(app_id).update.title
      rescue
        return false
      end
    end
    app_exists?('com.king.candycrushsaga')  # Return's true.
    app_exists?('com.some.fake.app.that.does.not.exist')  # Return's false.

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

## Excessive Use

Google will block your IP address if you attempt to scrape large quantities of data.
Please contact me if you are looking for commercial data solutions.

## Contributing to Market Bot

1. Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
2. Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
3. Fork the project.
4. Start a feature/bugfix branch.
5. Commit and push until you are happy with your contribution.
6. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
7. Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 - 2015 Chad Remesch. See LICENSE.txt for
further details.

