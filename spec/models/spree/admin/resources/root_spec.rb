require 'spec_helper'

module Spree
  module Admin
    describe Resources::Root, type: :model do
      let(:root) { described_class.new }

      describe '#key' do
        subject { root.key }

        it 'returns root' do
          expect(subject).to eq('root')
        end
      end

      describe '#add(item)' do
        let(:item) { double(key: 'test') }

        context "when there's no item with a particular key" do
          it 'appends an item' do
            root.add(item)
            expect(root.items).to include(item)
          end
        end

        # context "when there is an item with a particular key"
        #   it 'raises an error' do
            
        #   end
        # end
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
