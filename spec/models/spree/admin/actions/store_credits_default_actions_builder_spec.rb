require 'spec_helper'

module Spree
  module Admin
    describe Actions::StoreCreditsDefaultActionsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_actions) do
        %w(add_store_credit)
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
