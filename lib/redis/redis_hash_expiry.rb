require 'redis'
require 'json'

require_relative 'redis_base'

# Redis has a special hash type, which keeps the redis namespace clean, but
# doesn't allow expriations of the keys inside the hash.
#
# This class solves that problem by placing the keys in the global redis namespec.
# As long as the name provided upon creation is unique, this class acts like a hash.
#
# It might be tempting to replace redis_hash.rb with this code; however,
# that file is preferable when expirations aren't needed because the namespace
# is kept clean.

module Collectr
  class RedisHashExpiry < RedisBase
    attr_reader :store

    def initialize(name, options={})
      @title = name
      # Use raw only when both the keys and values are strings.
      @raw = options.fetch(:raw) { false }
      @store = Redis.current
      @default_expires_in = options[:expires_in]
    end

    def [](key)
      deserialize @store.get(key_name(key))
    end

    def []=(key, val, options={})
    	write(key, val, options)
    end
    
    def set_expiration(key, seconds)
    	return unless seconds
    	@store.expire(key_name(key), seconds)
    end

    def write(key, val, options={})
      expiration = options.fetch(:expires_in) { @default_expires_in }
      @store.set key_name(key), serialize(val)
      set_expiration(key, expiration)
      val
    end

    def fetch(key, options={})
      expiration = options.fetch(:expires_in) { @default_expires_in }
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
    	fetch(key, options) do
    		result = yield key
    		write(key, result, options)
    		result
    	end
    end

    def destroy 
    	keys.each{ |key| delete key }
    end

    def delete(key)
      @store.del key_name(key)
    end

    def empty?
      size == 0
    end

    def size
      keys.size
    end

    def has_key?(key)
      key? key
    end
    def key?(key)
      @store.exists key_name(key)
    end

    def keys
      @store.keys(key_prefix).collect{ |key| dekey key }
    end

    def to_hash
      hash = {}
      keys.each do |key|
        hash[key] = self[key]
      end
      hash
    end

    def clear
      destroy
      # keys.each{ |key| delete key }
    end
    
    def key_name(key)
    	"#{@title}-#{serialize(key)}"
    end
    
    def dekey(key)
    	deserialize(key[key_prefix.size-1..-1])
    end
    
    def key_prefix
    	@key_prefix ||= "#{@title}-*"
    end
  end
end
