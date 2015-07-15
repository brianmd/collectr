require 'spec_helper'
require 'bag'

describe Bag do
  subject(:bag) { Bag.new }

  it 'handles repetitions' do
    bag << 1 << 1 << 2 << 1 << 'a'
    expect(bag.keys).to eq([1,2,'a'])
  end

  it 'handles #each' do
    bag << 1 << 1 << 2 << 1 << 'a'
    hash = {}
    bag.each{ |key,val| hash[key] = val }
    expect(hash).to eq({1=>3, 2=>1, 'a'=>1})
  end
end
