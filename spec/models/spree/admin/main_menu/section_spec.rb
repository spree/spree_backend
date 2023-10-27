require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::Section, type: :model do
      let(:class_under_test) { described_class.new(key, label_translation_key, icon_key, availability_checks, items) }
      let(:key) { 'test-key' }
      let(:label_translation_key) { 'test-translation-key' }
      let(:icon_key) { 'icon-key' }
      let(:availability_checks) { [] }
      let(:items) { [] }

      it_behaves_like 'implements item manipulation and query methods'

      describe '#key' do
        subject { class_under_test.key }

        it 'returns key' do
          expect(subject).to eq(key)
        end
      end

      describe '#label_translation_key' do
        subject { class_under_test.label_translation_key }

        it 'returns translation key' do
          expect(subject).to eq(label_translation_key)
        end
      end

      describe '#icon_key' do
        subject { class_under_test.icon_key }

        it 'returns icon mey' do
          expect(subject).to eq(icon_key)
        end
      end

      describe '#available?' do
        subject { class_under_test.available?(ability, store) }

        let(:ability) { double}
        let(:store) { double }

        context 'when availability check is not set' do
          it 'is returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns true' do
          let(:availability_checks) { [->(_ability, _store) { true }] }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns false' do
          let(:availability_checks) { [->(_ability, _store) { false }] }

          it 'returns true' do
            expect(subject).to be(false)
          end
        end
      end

      describe '#children?' do
        subject { class_under_test.children? }

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
