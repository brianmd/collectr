require 'json'

require_relative 'redis_base'

module Collectr
  class RedisArray < RedisBase
    def initialize(name, options={})
      @title = name
      @max_size = options[:max_size] if options.has_key?(:max_size)
      @datastore = options[:datastore] if options.has_key?(:datastore)
    end

    def datastore
      @datastore ||= Redis.current
    end

    def <<(obj)
      add obj
    end

    def add(obj)
      datastore.rpush @title, serialize(obj)
      len = size
      if @max_size and len>@max_size
        datastore.ltrim @title, len-@max_size, -1
      end
    end

    def [](n)
      deserialize(datastore.lindex @title, n)
    end

    def pop
      deserialize(datastore.lpop @title)
    end

    def delete(obj)
      datastore.lrem @title, 0, serialize(obj)
    end

    def size
      datastore.llen @title
    end

    def to_a
      datastore.lrange(@title, 0, -1).collect{ |i| deserialize(i) }
    end

    def clear
      datastore.ltrim @title, 0, 0
      datastore.lpop @title
    end
  end
end
