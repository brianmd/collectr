require 'json'
require 'spec_helper'

if redis_exists?
  warn Redis.current.flushall
end

shared_examples 'a hash' do
  context 'when keys and/or values may be other than strings' do
    subject(:collection) { described_class.new 'example' }
    before { collection.destroy }
    after { collection.clear }
    context 'when newly created' do
      before { collection.clear }
      it { is_expected.to be_empty }
    end

    context 'after an item is added' do
      before { collection.clear ; collection[1] = 'a1' }
      it { expect(collection.size).to eq(1) }
      it { expect(collection.key?(1)).to be true }
      it { expect(collection.has_key?(1)).to be true }
      it { expect(collection[1]).to eq('a1') }
      it { collection.delete(1); expect(collection.size).to eq(0) }
    end

    context 'after multiple items are added' do
      before { collection.clear ; collection[1] = 'aa1' ; collection['b2'] = nil ; collection[[1,2]] = 3 }

      its(:size) { should eq(3) }
      it { expect(collection.keys.to_set).to eq([1, 'b2', [1,2]].to_set) }
      it { expect(collection.values.to_set).to eq(["aa1", nil, 3].to_set) }
      its(:to_hash) { should eq({1=>'aa1', 'b2'=>nil, [1,2]=>3}) }
      it { expect(collection.fetch(1)).to eq('aa1') }
      it { expect(collection.fetch('b2')).to eq(nil) }
      it { expect(collection.fetch('asdf') { 22 }).to eq(22) }
      it 'raises error when key does not exists' do
        expect{ collection.fetch(9) }.to raise_error(KeyError)
      end
    end
  end

  context 'when raw hash' do
    subject(:collection) { described_class.new 'example', raw: true }
    before { collection.destroy ; collection['1'] = 'a1' ; collection['b2'] = '2'; collection['[1,2]'] = '3' }
    after { collection.clear }
    its(:size) { should eq(3) }
    its(:to_hash) { should eq({'1'=>'a1', 'b2'=>'2', '[1,2]'=>'3'}) }
    it { expect(collection.keys.to_set).to eq(['1', 'b2', '[1,2]'].to_set)}
    it { expect(collection.to_hash).to eq({'1'=>'a1', 'b2'=>'2', '[1,2]'=>'3'}) }
  end

  context 'handles nil values' do
    subject(:collection) { described_class.new 'example' }
    before { collection['a'] = nil ; collection[:x] = 5 ; collection['x'] = 7 }

    it 'handles nil values' do expect(collection.fetch('a')).to be_nil end
# todo: symbols and strings are the same in redis, so need to fix this
    # it 'symbol key is distinct from string key' do expect(collection.fetch(:x)).to eq(5) end
    # it 'string key is distinct from symbol key' do expect(collection.fetch('x')).to eq(7) end
    it 'new value is retained' do collection['x'] = 9 ; expect(collection.fetch('x')).to eq(9) end
  end
end

