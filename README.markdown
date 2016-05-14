# Market Bot - [![Build Status](https://travis-ci.org/chadrem/market_bot.svg?branch=master)](https://travis-ci.org/chadrem/market_bot) [![Coverage Status](https://coveralls.io/repos/chadrem/market_bot/badge.svg?branch=master&service=github)](https://coveralls.io/github/chadrem/market_bot?branch=master)

Market Bot is a web scraper (web robot, web spider) for the Google Play Android app store.
It can collect data on apps, charts, and developers.

## Dependencies

* Nokogiri
* Typhoeus

## Installation

Add this line to your application's Gemfile to use the latest version:

    gem 'market_bot', git: 'https://github.com/chadrem/market_bot.git'

And then execute:

    $ bundle

## App API example

    # Download/parse the app.
    app = MarketBot::Play::App.new('com.facebook.katana')
    app.update

    # Print out the app title.
    puts app.title

    # Print all the other attributes you can find on an app object.
    puts MarketBot::Play::App::ATTRIBUTES.inspect

## Charts API example

    # Download/parse the chart.
    chart = MarketBot::Play::Chart.new(:topselling_free, :game)
    chart.update

    # Print the first app.
    puts chart.results.first.inspect

    # Print all the chart identifiers & categories for chart objects.
    puts MarketBot::Play::Chart::IDENTIFIERS.inspect
    puts MarketBot::Play::Chart::CATEGORIES.inspect

## Developer API example

    # Download/parse developer.
    dev = MarketBot::Play::Developer.new('Zynga')
    dev.update

    # Print the first app.
    puts dev.results.first.inspect

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

Copyright (c) 2011 - 2016 Chad Remesch. See LICENSE.txt for
further details.
