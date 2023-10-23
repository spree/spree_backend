module Spree
  module Admin
    module ItemAppender
      def add(item)
        raise KeyError, "Item with key #{item.key} already exists" if index_for_key(item.key)

        @items << item
      end
    end
  end
end
