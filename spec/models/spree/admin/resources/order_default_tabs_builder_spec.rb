require 'spec_helper'

module Spree
  module Admin
    describe Resources::OrderDefaultTabsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_tabs) do
        %i(cart
          channel
          customer
          shipments
          adjustments
          payments
          return_authorizations
          customer_returns
          state_changes)
      end

      describe '#build' do
        subject { builder.build }

        it 'builds default tabs' do
          # this means that tab items will need to respond to 'text' message,
          # just as section items respond to 'key' message
          expect(subject.items.map(&:text)).to match(default_tabs)
        end
      end
    end
  end
end
