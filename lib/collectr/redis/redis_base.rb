require 'redis'

module Collectr
  class RedisBase
    def serialize(val)
      @raw ? val : [val].to_json
    end
  
    def deserialize(val)
      @raw ? val : JSON.parse(val)[0]
    rescue
      val
    end
  end
end
