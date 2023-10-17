module Spree
  module Admin
    module ItemManager
      def add(item)
        raise KeyError, "Item with key #{item.key} already exists" if index_for_key(item.key)

        @items << item
      end

      private

      def index_for_key(key)
        @items.index { |e| e.key == key }
      end
    end
  end
end
