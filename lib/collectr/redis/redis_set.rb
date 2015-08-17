require 'redis'
require 'json'

module Collectr
  class RedisSet
    def initialize(name)
      @title = name
    end

    def datastore
      @datastore ||= Redis.current
    end

    def add(obj)
      datastore.sadd @title, obj
    end

    def delete(obj)
      datastore.srem @title, obj
    end

    def includes?(obj)
      datastore.sismember @title, obj
    end

    def to_a
      datastore.smembers @title
    end

    def clear
      to_a.each{ |obj| delete obj }
    end
  end
end
