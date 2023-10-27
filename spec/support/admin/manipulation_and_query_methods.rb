RSpec.shared_examples "implements item manipulation and query methods" do
  describe '#add' do
    subject { class_under_test.add(item) }
    let(:item) { double(key: 'test') }

    context "when there's no item with a particular key" do

      it 'appends an item' do
        subject
        expect(class_under_test.items).to include(item)
      end
    end

    context 'when there is an item with a particular key' do
      let(:items) { [item] }

      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end

  describe '#child_with_key?' do
    subject { class_under_test.child_with_key?(key) }
    let(:key) { 'key' }

    context 'when an item with given key exists' do
      let(:items) { [double(key: key), double(key: 'other-key')] }

      it 'returns true' do
        expect(subject).to be(true)
      end
    end

    context 'when an item with given key does not exist' do
      let(:items) { [double(key: 'other-key')] }

      it 'returns false' do
        expect(subject).to be(false)
      end
    end
  end

  describe '#remove' do
    subject { class_under_test.remove(key) }
    let(:key) { 'key' }
    let(:other_key) { 'other-key' }

    context 'when an item with given key exists' do
      let(:items) { [double(key: key), double(key: other_key)] }

      it 'removes the item' do
        subject
        expect(class_under_test.items.count).to eq(1)
        expect(class_under_test.items.first.key).to eq(other_key)
      end
    end

    context 'when an item with given key does not exist' do
      let(:items) { [double(key: 'other-key')] }

      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end

  describe '#item_for_key' do
    subject { class_under_test.item_for_key(key) }
    let(:key) { 'key' }

    context 'when an item with given key exists' do
      let(:items) { [double(key: 'other-key'), item] }
      let(:item) { double(key: key) }

      it 'returns the item' do
        expect(subject).to be(item)
      end
    end

    context 'when an item with given key does not exist' do
      let(:items) { [double(key: 'other-key')] }

      it 'returns nil' do
        expect(subject).to be(nil)
      end
    end
  end

  describe '#insert_before' do
    subject { class_under_test.insert_before(existing_key, item) }

    let(:item) { double(key: inserted_key) }
    let(:inserted_key) { 'test-item' }
    let(:existing_key) { 'test-old' }

    context 'when the list is empty' do
      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end

    context 'when an item with specified key does not exist' do
      let(:items) { [double(key: 'other-key'), double(key: 'other-key2')] }

      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end

    context 'when an item with specified key exists' do
      let(:items) { [double(key: 'other-key'), double(key: existing_key)] }

      it 'inserts the item before the other item' do
        subject
        expect(class_under_test.items.count).to eq(3)
        expect(class_under_test.items[1].key).to eq(inserted_key)
      end
    end
  end

  describe '#insert_after' do
    subject { class_under_test.insert_after(existing_key, item) }

    let(:item) { double(key: inserted_key) }
    let(:inserted_key) { 'test-item' }
    let(:existing_key) { 'test-old' }

    context 'when the list is empty' do
      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end

    context 'when an item with specified key does not exist' do
      let(:items) { [double(key: 'other-key'), double(key: 'other-key2')] }

      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end

    context 'when an item with specified key exists' do
      let(:items) { [double(key: existing_key), double(key: 'other-key')] }

      it 'inserts the item after the other item' do
        subject
        expect(class_under_test.items.count).to eq(3)
        expect(class_under_test.items[1].key).to eq(inserted_key)
      end
    end
  end
end
