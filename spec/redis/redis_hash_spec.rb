require 'spec_helper'
require 'redis/redis_hash'
require 'hash_spec'

describe Collectr::RedisHash do
  it_behaves_like 'a hash'
end
