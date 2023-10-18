require 'spec_helper'

module Spree
  module Admin
    describe Tabs::UserDefaultTabsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_tabs) do
        ['admin.user.account',
         'admin.user.addresses',
         'admin.user.orders',
         'admin.user.items',
         'admin.user.store_credits']
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
