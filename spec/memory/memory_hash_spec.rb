require 'spec_helper'
require 'memory/memory_hash.rb'
require 'hash_spec'

describe Collectr::MemoryHash do
  it_behaves_like 'a hash'
end
