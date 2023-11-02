require 'spec_helper'

module Spree
  module Admin
    describe Tabs::OrderDefaultTabsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_tabs) do
        %w(cart
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
          expect(subject.items.map(&:key)).to match(default_tabs)
        end
      end
    end
  end
end
