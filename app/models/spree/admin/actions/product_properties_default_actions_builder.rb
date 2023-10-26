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
            ActionBuilder.new(select_from_prototype_config).
            build

          root.add(action)
        end

        def select_from_prototype_config
          {
            icon_name: 'list.svg',
            key: :select_from_prototype,
            url: available_admin_prototypes_path,
            classes: 'btn-light js-new-ptype-link',
            data: { update: 'prototypes', remote: true }
          }
        end

        def add_add_product_properties_action(root)
          action =
            ActionBuilder.new(add_product_properties_config).
            with_create_ability_check(::Spree::ProductProperty).
            build

          root.add(action)
        end

        def add_product_properties_config
          {
            icon_name: 'add.svg',
            key: :add_product_properties,
            url: 'javascript:;',
            classes: 'btn-success spree_add_fields',
            data: { target: 'tbody#sortVert' }
          }
        end
      end
    end
  end
end
