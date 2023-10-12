require 'spec_helper'

module Spree
  module Admin
    describe Actions::UsersDefaultActionsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_actions) do
        %i(new_user)
      end

      describe '#build' do
        subject { builder.build }

        it 'builds default tabs' do
          expect(subject.items.map(&:name)).to match(default_actions)
        end
      end
    end
  end
end
