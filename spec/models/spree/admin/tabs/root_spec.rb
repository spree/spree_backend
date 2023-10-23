require 'spec_helper'

module Spree
  module Admin
    describe Tabs::Root, type: :model do
      let(:root) { described_class.new }
      let(:items) { [] }

      before do
        items.each { |i| root.add(i) }
      end

      it_behaves_like "implements item manipulation and query methods"
      it_behaves_like "implements item appendage"
    end
  end
end
