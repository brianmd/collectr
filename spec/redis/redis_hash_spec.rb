require 'spec_helper'
require 'redis/redis_hash'
require 'hash_spec'

if redis_exists?
	describe Collectr::RedisHash do
	  it_behaves_like 'a hash'
	end
end
