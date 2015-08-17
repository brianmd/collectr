require 'spec_helper'
require 'collectr/redis/redis_hash_expiry'
require 'hash_spec_helper'

if redis_exists?
	describe Collectr::RedisHashExpiry do
		
	  it_behaves_like 'a hash'
	  
	  describe 'expires' do
	  	subject(:collection) { described_class.new 'expiry', expires_in: 1 }
	  	before{ collection.destroy }
	  	
	  	it 'after the default one second' do
	  		collection['three'] = 3
	      expect(collection['three']).to eq(3)
	  		sleep 1.1
	  		expect(collection['three']).to be_nil
	  	end
	  	
	  	it 'write after overridden 2 second expiration' do
	  		collection.write('nine', 9, expires_in: 2)
	      expect(collection['nine']).to eq(9)
	      sleep 1.3
	  		expect(collection['nine']).to eq(9)
	  		sleep 0.8
	  		expect(collection['nine']).to be_nil
	  	end
	  	
	  	it 'cache after overridden 2 seconds' do
	  		collection.cache('ten', expires_in: 2) { 10 }
	  		collection.cache('ten', expires_in: 5) { 20 }
	      expect(collection['ten']).to eq(10)
	      sleep 1.1
	  		expect(collection['ten']).to eq(10)
	      sleep 1
	  		expect(collection['ten']).to eq(nil)
	  	end
	  end
	end
end
