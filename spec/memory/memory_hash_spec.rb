require 'spec_helper'
require 'collectr/memory/memory_hash.rb'
require 'hash_spec_helper'

describe Collectr::MemoryHash do
  it_behaves_like 'a hash'
end
