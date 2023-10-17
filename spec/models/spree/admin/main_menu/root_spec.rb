require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::Root, type: :model do
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

      describe '#remove' do
        subject { root.remove(key) }
        let(:key) { 'key' }
        let(:other_key) { 'other-key' }

        before do
          items.each { |i| root.add(i) }
        end

        context 'when an item with given key exists' do
          let(:items) { [double(key: key), double(key: other_key)] }

          it 'removes the item' do
            subject
            expect(root.items.count).to eq(1)
            expect(root.items.first.key).to eq(other_key)
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
        subject { root.item_for_key(key) }
        let(:key) { 'key' }

        before do
          items.each { |i| root.add(i) }
        end

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
        subject { root.insert_before(existing_key, item) }

        let(:item) { double(key: inserted_key) }
        let(:inserted_key) { 'test-item' }
        let(:existing_key) { 'test-old' }
        let(:items) { [] }

        before do
          items.each { |i| root.add(i) }
        end

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
            expect(root.items.count).to eq(3)
            expect(root.items[1].key).to eq(inserted_key)
          end
        end
      end

      describe '#key' do
        subject { root.key }

        it 'returns root' do
          expect(subject).to eq('root')
        end
      end

      describe '#label_translation_key' do
        subject { root.label_translation_key }

        it 'returns root' do
          expect(subject).to eq('root')
        end
      end

      describe '#icon_key' do
        subject { root.icon_key }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end

      describe '#available?' do
        subject { root.available?(ability, store) }

        let(:ability) { double }
        let(:store) { double }

        it 'is always set to true' do
          expect(subject).to be(true)
        end
      end

      describe '#children?' do
        subject { root.children? }

        context 'when there are child items' do
          before { root.add(double(key: 'test')) }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when there are no child items' do
          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
