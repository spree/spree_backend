require 'spec_helper'

module Spree
  module Admin
    describe Resources::ProductDefaultTabsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_tabs) do
        [:details,
         :images,
         :variants,
         :properties,
         :stock,
         :prices,
         'admin.digitals.digital_assets',
         :translations]
      end

      describe '#build' do
        subject { builder.build }

        it 'builds default tabs' do
          # this means that tab items will need to respond to 'text' message,
          # just as section items respond to 'key' message
          expect(subject.items.map(&:name)).to match(default_tabs)
        end
      end
    end
  end
end
