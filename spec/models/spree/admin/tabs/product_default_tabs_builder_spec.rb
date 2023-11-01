require 'spec_helper'

module Spree
  module Admin
    describe Tabs::ProductDefaultTabsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_tabs) do
        %w(details
           images
           variants
           properties
           stock
           prices
           digital_assets
           translations)
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
