class MemoryFactory
  def initialize(redis_store=nil)
  end

  def hash(title=default_title, options={})
    MemoryHash.new title, options
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
