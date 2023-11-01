module Spree
  module Admin
    module Actions
      class Root
        include ::Spree::Admin::ItemManager

        attr_reader :items

        def initialize
          @items = []
        end
      end
    end
  end
end
