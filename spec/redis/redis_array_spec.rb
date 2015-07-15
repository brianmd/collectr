require 'spec_helper'

require 'redis/redis_array'

if redis_exists?
  describe Collectr::RedisArray do
    subject(:array) { coll = Collectr::RedisArray.new('arr', max_size: 3); coll.clear; coll }

    it 'keeps only the last three' do
      array << 1
      array << 2
      array << 3
      array << 4
      array << 5
      expect(array.to_a).to eq([3,4,5])
    end
  end
end
