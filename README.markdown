# Market Bot - High performance Ruby scraper for Google's Android Market

Market Bot is a high performance Ruby scraper for Google's Android Market with a simple to use API.
It is built on top of Nokogiri and Typhoeus.
Used in production to power [www.droidmeter.com](http://www.droidmeter.com).

## Dependencies

* Nokogiri
* Typhoeus

## Installation

    gem install market_bot

## Usage Examples (using batch API for downloading)

    require 'rubygems'
    require 'market_bot'

    # Create a hydra object with 20 http workers.
    hydra = Typhoeus::Hydra.new(:max_concurrency => 20)

    # Download/parse the leaderboard.
    lb = MarketBot::Android::Leaderboard.new(:apps_topselling_paid, :arcade, :hydra => hydra)
    lb.enqueue_update
    hydra.run

    # Download/parse the details for the first and last entries of the leaderboard.
    first_app = MarketBot::Android::App.new(lb.results.first[:market_id], :hydra => hydra)
    last_app = MarketBot::Android::App.new(lb.results.last[:market_id], :hydra => hydra)
    first_app.enqueue_update
    last_app.enqueue_update do |a|
      # Callback example.  This block will execute on a successful hydra.run.
      puts "Callback... title: #{a.title}"
    end
    hydra.run

    # Non-callback example.  Note that you must manually check if an error occurred during the hydra.run.
    puts "First place app (#{first_app.title}) price: #{first_app.price}" unless first_app.error
    puts "Last place app (#{last_app.title}) price: #{last_app.price}" unless last_app.error

## Benchmarks

Below are fairly typical results using 20 http workers (Typhoeus::Hydra.new(:max_concurrency => 20).  The first benchmark downloads/parses a leaderboard containing 504 entries.  The second benchmark takes those 504 entries, converts them to MarketBot::Android::App objects and then downloads/parses their details.  Note that 20 workers are used to prevent DOSing the market servers.  Higher values may work, but I don't recommend it.

    $ rake benchmark:android
    ----------------------------------------------------
    Benchmark Leaderboard: Top Selling Paid Apps
    ----------------------------------------------------
    app count: 504
    time: 3.16 seconds

    ----------------------------------------------------
    Benchmark Apps: top Selling Paid Apps
    ----------------------------------------------------
    app count: 504
    time: 35.685 seconds

## Contributing to Market Bot

1. Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
2. Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
3. Fork the project.
4. Start a feature/bugfix branch.
5. Commit and push until you are happy with your contribution.
6. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
7. Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Chad Remesch. See LICENSE.txt for
further details.

