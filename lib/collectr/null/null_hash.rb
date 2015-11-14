module Collectr
  class NullHash
    attr_reader :store

    def initialize(name, options={})
      @title = name
    end

    def [](key)
    end

    def []=(key, val)
    end

    def fetch(key)
      yield(key) if block_given?
    end

    def delete(key)
    end

    def empty?
      true
    end

    def size
      0
    end

    def has_key?(key)
      false
    end
    def key?(key)
      false
    end

    def keys
      []
    end

    def values
      Set.new
    end

    def to_hash
      {}
    end

    def clear
    end
  end
end
