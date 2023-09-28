module Spree
  module Admin
    module Resources
      class Root
        attr_reader :items

        def initialize
          @items = []
        end

        def add(item)
          raise KeyError, "Item with key #{item.name} already exists" if index_for_name(item.name)

          @items << item
        end

        private

        def index_for_name(name)
          @items.index { |e| e.name == name }
        end
      end
    end
  end
end
