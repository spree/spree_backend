module Spree
  module Admin
    module Actions
      class ProductPropertiesDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_select_from_prototype_action(root)
          add_add_product_properties_action(root)
          root
        end

        private

        def add_select_from_prototype_action(root)
          action =
            ActionBuilder.new('select_from_prototype', available_admin_prototypes_path).
            with_icon_key('list.svg').
            with_classes('js-new-ptype-link').
            with_data_attributes({ update: 'prototypes', remote: true }).
            build

          root.add(action)
        end

        def add_add_product_properties_action(root)
          action =
            ActionBuilder.new('add_product_properties', 'javascript:;').
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_classes('spree_add_fields').
            with_data_attributes({ target: 'tbody#sortVert' }).
            with_create_ability_check(::Spree::ProductProperty).
            build

          root.add(action)
        end
      end
    end
  end
end
