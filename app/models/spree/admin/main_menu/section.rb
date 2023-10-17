module Spree
  module Admin
    module MainMenu
      class Section
        attr_reader :key, :label_translation_key, :icon_key, :items

        def initialize(key, label_translation_key, icon_key, availability_check, items)
          @key = key
          @label_translation_key = label_translation_key
          @icon_key = icon_key
          @availability_check = availability_check
          @items = items
        end

        def insert_after(item_key, item_to_add)
          item_index = index_for_key!(item_key)

          @items.insert(item_index + 1, item_to_add)
        end

        def available?(current_ability, current_store)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, current_store)
        end

        def children?
          @items.any?
        end

        private

        def index_for_key!(key)
          item_index = index_for_key(key)
          raise KeyError, "Item not found for key #{key}" unless item_index

          item_index
        end
      end
    end
  end
end
