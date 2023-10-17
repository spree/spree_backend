require 'spec_helper'

module Spree
  module Admin
    describe Tabs::Root, type: :model do
      let(:root) { described_class.new }

      describe '#add' do
        let(:item) { double(name: 'test') }

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
    end
  end
end
