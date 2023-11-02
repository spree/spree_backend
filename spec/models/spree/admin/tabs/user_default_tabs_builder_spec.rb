require 'spec_helper'

module Spree
  module Admin
    describe Tabs::UserDefaultTabsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_tabs) do
        ['account',
         'addresses',
         'orders',
         'items',
         'store_credits']
      end

      describe '#build' do
        subject { builder.build }

        it 'builds default tabs' do
          expect(subject.items.map(&:key)).to match(default_tabs)
        end
      end
    end
  end
end
