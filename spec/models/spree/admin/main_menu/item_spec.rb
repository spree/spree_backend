require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::Item, type: :model do
      let(:item) { described_class.new(key, label_translation_key, url, icon_key, availability_checks, match_path) }
      let(:key) { 'test-key' }
      let(:label_translation_key) { 'test-translation-key' }
      let(:url) { '/test' }
      let(:icon_key) { 'icon-key' }
      let(:availability_checks) { [] }
      let(:match_path) { nil }

      describe '#key' do
        subject { item.key }

        it 'returns key' do
          expect(subject).to eq(key)
        end
      end

      describe '#label_translation_key' do
        subject { item.label_translation_key }

        it 'returns translation key' do
          expect(subject).to eq(label_translation_key)
        end
      end

      describe '#url' do
        subject { item.url }

        it 'returns translation key' do
          expect(subject).to eq(url)
        end
      end


      describe '#icon_key' do
        subject { item.icon_key }

        it 'returns icon mey' do
          expect(subject).to eq(icon_key)
        end
      end

      describe '#match_path' do
        subject { item.match_path }

        it 'returns match path' do
          expect(subject).to eq(match_path)
        end
      end

      describe '#available?' do
        subject { item.available?(ability, store) }

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
        subject { item.children? }

        it 'returns false' do
          expect(subject).to be(false)
        end
      end
    end
  end
end
