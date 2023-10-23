require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::Root, type: :model do
      let(:root) { described_class.new }
      let(:items) { [] }

      before do
        items.each { |i| root.add(i) }
      end

      it_behaves_like "implements item manipulation and query methods"
      it_behaves_like "implements item appendage"

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
    end
  end
end
