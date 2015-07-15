module Collectr
  class RedisFactory
    def initialize(redis_store=nil)
      @store = redis_store || Redis.current
    end

    def hash(title=default_title, options={})
      options = { store: @store }.merge options
      # RedisHash.new title, store: @store, *options
    end

    def set(title=default_title)
      RedisSet.new title, store: @store
    end

    def array(title=default_title)
      RedisArray.new title, store: @store
    end

    private

    def default_title
      Time.now.to_s
    end
  end
end
