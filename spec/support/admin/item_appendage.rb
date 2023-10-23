RSpec.shared_examples "implements item appendage" do
  describe '#add' do
    subject { root.add(item) }
    let(:item) { double(key: 'test') }

    context "when there's no item with a particular key" do

      it 'appends an item' do
        subject
        expect(root.items).to include(item)
      end
    end

    context 'when there is an item with a particular key' do
      let(:items) { [item] }

      it 'raises an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end
end