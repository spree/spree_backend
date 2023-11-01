module Spree
  module Admin
    module MainMenu
      class Section
        include ::Spree::Admin::ItemManager

        attr_reader :key, :label_translation_key, :icon_key, :items

        def initialize(key, label_translation_key, icon_key, availability_checks, items)
          @key = key
          @label_translation_key = label_translation_key
          @icon_key = icon_key
          @availability_checks = availability_checks
          @items = items
        end

        def available?(current_ability, resource)
          return true if @availability_checks.empty?

          result = @availability_checks.map { |check| check.call(current_ability, resource) }

          result.all?(true)
        end

        def children?
          @items.any?
        end
      end
    end
  end
end
