require 'spec_helper'
require 'collectr/redis/redis_hash'
require 'hash_spec_helper'

if redis_exists?
	describe Collectr::RedisHash do
	  it_behaves_like 'a hash'
	end
end
