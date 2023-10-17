require 'spec_helper'

module Spree
  module Admin
    describe Tabs::Root, type: :model do
      let(:root) { described_class.new }

      describe '#add' do
        let(:item) { double(key: 'test') }

        context "when there's no item with a particular key" do
          it 'appends an item' do
            root.add(item)
            expect(root.items).to include(item)
          end
        end

        context 'when there is an item with a particular key' do
          before { root.add(item) }

          it 'raises an error' do
            expect { root.add(item) }.to raise_error(KeyError)
          end
        end
      end

      describe '#child_with_key?' do
        subject { root.child_with_key?(key) }
        let(:key) { 'key' }

        context 'when an item with given key exists' do
          let(:items) { [double(key: key), double(key: 'other-key')] }

          before do
            items.each { |i| root.add(i) }
          end

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when an item with given key does not exist' do
          let(:items) { [double(key: 'other-key')] }

          before do
            items.each { |i| root.add(i) }
          end

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
