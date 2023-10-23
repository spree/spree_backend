module Spree
  module Admin
    module Tabs
      class Root
        include ::Spree::Admin::ItemManager
        include ::Spree::Admin::ItemAppender

        attr_reader :items

        def initialize
          @items = []
        end
      end
    end
  end
end
