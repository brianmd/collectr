require 'thread_safe'

module Collectr
  class MemoryHash
    attr_reader :store

    def initialize(name, options={})
      @title = name
      @store ||= ThreadSafe::Hash.new
    end

    def [](key)
      @store[key]
    end

    def []=(key, val)
      @store[key] = val
    end

    def fetch(key, &block)
      @store.fetch(key, &block)
      # @store.fetch(key) do
      #   block_given? ? yield(key) : nil
      # end
    end

    def destroy
      @store ||= ThreadSafe::Hash.new
    end

    def delete(key)
      @store.delete key
    end

    def empty?
      @store.empty?
    end

    def size
      @store.size
    end

    def has_key?(key)
      key? key
    end
    def key?(key)
      @store.has_key? key
    end

    def keys
      @store.keys
    end

    def values
      @store.values
    end

    def to_hash
      @store  #.copy
    end

    def clear
      @store.clear
    end
  end
end
