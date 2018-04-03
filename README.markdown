# Market Bot - [![Build Status](https://travis-ci.org/chadrem/market_bot.svg?branch=master)](https://travis-ci.org/chadrem/market_bot) [![Coverage Status](https://coveralls.io/repos/github/chadrem/market_bot/badge.svg?branch=master)](https://coveralls.io/github/chadrem/market_bot?branch=master)

Market Bot is a web scraper (web robot, web spider) for the Google Play Android app store.
It can collect data on apps, charts, and developers.

**Google has recently changed the HTML and CSS for the Play Store.
This has caused the release version of Market Bot to break.
New code is in the master branch (unreleased) to begin fixing this problem.
If you are interesed in helping then please join the discussion in [issue 72](https://github.com/chadrem/market_bot/issues/72).**

## Dependencies

* Ruby MRI 2.1.X or newer
* Nokogiri gem
* Typhoeus gem

## Installation

Add this line to your application's Gemfile to use the latest stable version:

    gem 'market_bot'

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

Charts are defined by a collection and an option category.

    # Download/parse the chart (collection=topselling_free, category=GAME).
    chart = MarketBot::Play::Chart.new('topselling_free', 'GAME')
    chart.update

    # Print the first app.
    puts chart.result.first.inspect

    # Print all the chart collections & categories.
    puts MarketBot::Play::Chart::COLLECTIONS.inspect
    puts MarketBot::Play::Chart::CATEGORIES.inspect

## Developer API example

    # Download/parse developer.
    dev = MarketBot::Play::Developer.new('Zynga')
    dev.update

    # Print the first app.
    puts dev.result.first.inspect

## Language and Country support

Market Bot defaults to USA and English.
You can specify a country and a language to override the defaults when creating objects:

    chart = MarketBot::Play::Chart.new('topselling_paid', 'BUSINESS', country: 'jp', lang: 'ja')
    chart.update

    app = MarketBot::Play::App.new('com.facebook.katana', country: 'jp', lang: 'ja')
    app.update

## Excessive Use

Google will block your IP address if you attempt to scrape large quantities of data.

## Contributing to Market Bot

1. Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
2. Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
3. Fork the project.
4. Start a feature/bugfix branch.
5. Commit and push until you are happy with your contribution.
6. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
7. Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 - 2018 Chad Remesch. See LICENSE.txt for
further details.
