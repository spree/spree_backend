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

      it_behaves_like "implements item appendage"

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
    end
  end
end
