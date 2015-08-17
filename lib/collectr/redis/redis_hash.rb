require 'redis'
require 'json'

require_relative 'redis_base'

# __FILE__.has_spec 'common/spec/classes/collection/hash_spec'


# class Redis
#   def fetch(key, options={})
#     val = self[key]
#     if val.nil?
#       begin
#         val = yield key
#         self[key] = val
#       end
#     end
#     val
#   end
# end


module Collectr
  class RedisHash < RedisBase
    attr_reader :store

    def initialize(name, options={})
      @title = name
      # Use raw only when both the keys and values are strings.
      @raw = options.fetch(:raw) { false }
      @store = Redis.current
      @expires_in = options[:expires_in]
    end

    def [](key)
      deserialize @store.hget(@title, serialize(key))
    end

    def []=(key, val)
      @store.hset @title, serialize(key), serialize(val)
    end

    def fetch(key, options={})
      result = self[key]
      if result.nil?
        return nil if has_key?(key)
        if block_given?
          result = yield key
        else
          raise KeyError
        end
      end
      result
    end

    def cache(key, options={})
      result = self[key]
      if result.nil? and block_given?
        result = yield key
        self[key] = result
      else
        raise KeyError
      end
      result
    end

    def destroy
      @store.del @title
    end

    def delete(key)
      @store.hdel @title, serialize(key)
    end

    def empty?
      size == 0
    end

    def size
      @store.hlen @title
    end

    def has_key?(key)
      key? key
    end
    def key?(key)
      @store.hexists @title, serialize(key)
    end

    def keys
      @store.hkeys(@title).collect{ |key| deserialize key }
    end

    def to_hash
      hash = {}
      @store.hgetall(@title).each do |key, val|
        hash[deserialize(key)] = deserialize(val)
      end
      hash
    end

    def clear
      destroy
      # keys.each{ |key| delete key }
    end
  end
end
