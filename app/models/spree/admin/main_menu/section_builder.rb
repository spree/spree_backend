module Spree
  module Admin
    module MainMenu
      class SectionBuilder
        include ::Spree::Admin::PermissionChecks

        def initialize(key, icon_key)
          @key =                   key
          @label_translation_key = key
          @icon_key =              icon_key
          @availability_checks =   []
          @items =                 []
        end

        def with_label_translation_key(key)
          @label_translation_key = key
          self
        end

        def with_item(item)
          @items << item
          self
        end

        def with_items(items)
          @items += items
          self
        end

        def build
          Section.new(@key, @label_translation_key, @icon_key, @availability_checks, @items)
        end
      end
    end
  end
end
