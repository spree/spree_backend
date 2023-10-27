require 'spec_helper'

module Spree
  module Admin
    describe Tabs::Root, type: :model do
      let(:class_under_test) { described_class.new }
      let(:items) { [] }

      before do
        items.each { |i| class_under_test.add(i) }
      end

      it_behaves_like 'implements item manipulation and query methods'
    end
  end
end
