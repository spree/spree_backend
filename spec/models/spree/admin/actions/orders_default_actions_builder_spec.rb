require 'spec_helper'

module Spree
  module Admin
    describe Actions::OrdersDefaultActionsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_actions) do
        %w(new_order)
      end

      describe '#build' do
        subject { builder.build }

        it 'builds default tabs' do
          expect(subject.items.map(&:key)).to match(default_actions)
        end
      end
    end
  end
end
