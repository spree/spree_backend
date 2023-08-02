require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::Root, type: :model do
      let(:root) { described_class.new }

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
