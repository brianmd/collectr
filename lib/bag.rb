class Bag
  include Enumerable

  def initialize(collection=nil)
    @bag = Hash.new{ 0 }
    collection.each{ |item| self << item } if collection
  end

  def add(obj)
    @bag[obj] += 1
    self
  end

  def <<(obj)
    add(obj)
  end

  def [](obj)
    @bag[obj]
  end

  def keys
    @bag.keys
  end

  def size
    @bag.size
  end

  def count
    sum = 0
    each{ |key, val| sum += val }
    sum
  end

  def each(&block)
    @bag.each{ |k,v| block.call k,v }
  end

  def bag
    @bag
  end

  def empty?
    @bag.empty?
  end

  def as_sorted_counts
    @bag.sort_by{ |key, cnt| cnt }
  end

  def initialize_copy(source)
    @bag = source.bag.clone
    super
  end
end
