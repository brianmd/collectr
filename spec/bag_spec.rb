require 'spec_helper'
require 'bag'

describe Collectr::Bag do
  subject(:bag) { Bag.new }

  it 'handles empty bag' do
    expect(bag).to be_empty
    expect(bag.size).to eq(0)
    expect(bag.count).to eq(0)
    expect(bag.bag).to eq({})
    expect(bag.as_sorted_counts).to eq([])
  end

  it 'handles repetitions' do
    bag << 1 << 1 << 2 << 1 << 'a'
    expect(bag.keys).to eq([1,2,'a'])
  end

  it 'clones well' do
    bag << 1 << 1 << 2 << 1 << 'a'
    new_bag = bag.clone
    expect(    bag.as_sorted_counts).to eq([[1,3],[2,1],['a',1]])
    expect(new_bag.as_sorted_counts).to eq([[1,3],[2,1],['a',1]])
    bag << 'a'
    expect(    bag.as_sorted_counts).to eq([[1,3],['a',2],[2,1]])
    expect(new_bag.as_sorted_counts).to eq([[1,3],[2,1],['a',1]])
  end

  it 'handles #each' do
    bag << 1 << 1 << 2 << 1 << 'a'
    hash = {}
    bag.each{ |key,val| hash[key] = val }
    expect(bag.size).to eq(3)
    expect(bag.count).to eq(5)
    expect(hash).to eq({1=>3, 2=>1, 'a'=>1})
    expect(bag[1]).to eq(3)
    expect(bag['a']).to eq(1)
    expect(bag.bag).to eq(hash)
    expect(bag.as_sorted_counts).to eq([[1,3],[2,1],['a',1]])
  end
end
