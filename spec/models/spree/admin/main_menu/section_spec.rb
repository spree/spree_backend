require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::Section, type: :model do
      let(:section) { described_class.new(key, label_translation_key, icon_key, availability_check, items) }
      let(:key) { 'test-key' }
      let(:label_translation_key) { 'test-translation-key' }
      let(:icon_key) { 'icon-key' }
      let(:availability_check) { nil }
      let(:items) { [] }

      describe '#key' do
        subject { section.key }

        it 'returns key' do
          expect(subject).to eq(key)
        end
      end

      describe '#label_translation_key' do
        subject { section.label_translation_key }

        it 'returns translation key' do
          expect(subject).to eq(label_translation_key)
        end
      end

      describe '#icon_key' do
        subject { section.icon_key }

        it 'returns icon mey' do
          expect(subject).to eq(icon_key)
        end
      end

      describe '#available?' do
        subject { section.available?(ability, store) }

        let(:ability) { double}
        let(:store) { double }

        context 'when availability check is not set' do
          it 'is returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns true' do
          let(:availability_check) { ->(_ability, _store) { true } }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns false' do
          let(:availability_check) { ->(_ability, _store) { false } }

          it 'returns true' do
            expect(subject).to be(false)
          end
        end
      end

      describe '#children?' do
        subject { section.children? }

        context 'when there are child items' do
          let(:items) { [double] }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when there are no child items' do
          let(:items) { [] }

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end

      describe '#remove' do
        subject { section.remove(key) }
        let(:key) { 'test-key' }
        let(:other_key) { 'other-key' }

        context 'when the element is present in an array' do
          let(:items) { [double(key: key), double(key: other_key)] }

          it 'removes the item' do
            subject
            expect(items.count).to eq(1)
            expect(items.first.key).to eq(other_key)
          end
        end

        context 'when the element is not present in an array' do
          let(:items) { [double(key: other_key)] }

          it 'removes the item' do
            expect { subject }.to raise_error(KeyError)
          end
        end
      end

      describe '#child_with_key?' do
        subject { section.child_with_key?(key) }
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

      describe '#item_for_key' do
        subject { section.item_for_key(key) }
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
        subject { section.insert_before(existing_key, item) }

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
            expect(section.items.count).to eq(3)
            expect(section.items[1].key).to eq(inserted_key)
          end
        end
      end

      describe '#insert_after' do
        subject { section.insert_after(existing_key, item) }

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
            expect(section.items.count).to eq(3)
            expect(section.items[1].key).to eq(inserted_key)
          end
        end
      end
    end
  end
end
