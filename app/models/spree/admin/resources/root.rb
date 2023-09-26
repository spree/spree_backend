module Spree
  module Admin
    module Resources
      class Root
        attr_reader :items

        def initialize
          @items = []
        end

        def add(item)
          raise KeyError, "Item with key #{item.text} already exists" if index_for_key(item.text)

          @items << item
        end

        private

        def index_for_key(key)
          @items.index { |e| e.key == key }
        end
      end
    end
  end
end
