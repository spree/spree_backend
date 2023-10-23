module Spree
  module Admin
    module ItemManager
      def add(item)
        raise KeyError, "Item with key #{item.key} already exists" if index_for_key(item.key)

        @items << item
      end

      def child_with_key?(key)
        index_for_key(key).present?
      end

      def remove(item_key)
        item_index = index_for_key!(item_key)

        @items.delete_at(item_index)
      end

      def item_for_key(key)
        @items.find { |e| e.key == key }
      end

      def insert_before(item_key, item_to_add)
        item_index = index_for_key!(item_key)

        @items.insert(item_index, item_to_add)
      end

      def insert_after(item_key, item_to_add)
        item_index = index_for_key!(item_key)

        @items.insert(item_index + 1, item_to_add)
      end

      private

      def index_for_key(key)
        @items.index { |e| e.key == key }
      end

      def index_for_key!(key)
        item_index = index_for_key(key)
        raise KeyError, "Item not found for key #{key}" unless item_index

        item_index
      end
    end
  end
end
