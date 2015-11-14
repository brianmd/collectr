[![Build Status](https://api.travis-ci.org/brianmd/collectr.png?branch=master)](https://travis-ci.org/brianmd/collectr)  [![Gem Version](https://badge.fury.io/rb/collectr.png)](http://badge.fury.io/rb/collectr)  [![Coverage Status](https://coveralls.io/repos/brianmd/collectr/badge.svg?branch=master&service=github)](https://coveralls.io/github/brianmd/collectr?branch=master)

# Collectr

Abstraction for thread-safe collections (array, hash, set, bag).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collectr'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install collectr

## Usage

```ruby
require 'collectr/redis/redis_hash'
x = Collectr::RedisHash.new('example')
x[3] = 7
x[3]
  => 7
x.fetch(3) { 88 }
  => 7
x.fetch(:not_found) { 88 }
  => 88
```

```ruby
require 'collectr/redis/redis_hash_expiry'
x = Collectr::RedisHashExpiry.new('example', expires_in: 60)
x['purple'] = :blue
x['purple']
  => "blue"
sleep 61
x['purple']
  => nil
x.write('nine', 9, expires_in: 2)
x['nine']
```

```ruby
require 'collectr/memory/memory_hash'
x = Collectr::MemoryHash.new('example')
x[:a] = 'abc'
x[:a]
  => "abc"
```

```ruby
require 'collectr/redis/redis_array'
array = Collectr::RedisArray.new('arr', max_size: 3)
array.clear
array << 'a'
array << 'b'
array.to_a
  => ["a", "b"]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/collectr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
