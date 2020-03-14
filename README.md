# CurrentAstronauts

![](https://github.com/hortoncd/current_astronauts/workflows/Ruby/badge.svg)

Small gem to work with the list of current astronauts in space from http://api.open-notify.org/astros.json.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'current_astronauts'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install current_astronauts

## Usage

require the gem, and optionally include the module for simplicity
```ruby
require 'current_astronauts'

include CurrentAstronauts
```

Instantiate an object and fetch data.  If success?, use the data as desired.
```ruby
a = Astronauts.new
a.fetch
if a.success?
  # do something here
end
```

The URL source defaults to http://api.open-notify.org/astros.json, but if you set ENV['OPEN_NOTIFY_URL'] before instantiating the object, it will use the set URL instead.

```ruby
ENV['OPEN_NOTIFY_URL']
a = Astronauts.new
```

a.data contains the full data as returned in a hash.  There are methods to work with smaller portions of the data.

How many astronauts are currently in space?
```ruby
puts "there are currently #{a.num} astronauts currently in space."
```

Use the 'people' method to work with the list of astronauts and their associated craft.  It is an array of hashes.
```ruby
people = a.people
first = a.people.first

puts "a.people returns a list of people and their associated craft as an #{people.class} of type #{first.class}."
puts
puts "#{first['name']} is currently on: #{first['craft']}."
```

Print a formatted list of astronauts and their associated craft.
```ruby
a.print
```

Formatted list appears as follows.

```
Name              | Craft
------------------|-------------
Anatoly Ivanishin | ISS
Takuya Onishi     | ISS
Kate Rubins       | ISS
Jing Haipeng      | Shenzhou 11
Chen Dong         | Shenzhou 11
Sergey Rizhikov   | ISS
Andrey Borisenko  | ISS
Shane Kimbrough   | ISS
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hortoncd/current_astronauts.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
