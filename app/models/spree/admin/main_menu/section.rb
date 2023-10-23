module Spree
  module Admin
    module MainMenu
      class Section
        include ::Spree::Admin::ItemManager

        attr_reader :key, :label_translation_key, :icon_key, :items

        def initialize(key, label_translation_key, icon_key, availability_check, items)
          @key = key
          @label_translation_key = label_translation_key
          @icon_key = icon_key
          @availability_check = availability_check
          @items = items
        end

        def available?(current_ability, current_store)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, current_store)
        end

        def children?
          @items.any?
        end
      end
    end
  end
end
