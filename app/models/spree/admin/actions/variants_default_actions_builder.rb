module Spree
  module Admin
    module Actions
      class VariantsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_variant_action(root)
          root
        end

        private

        def add_new_variant_action(root)
          action =
            ActionBuilder.new(new_variant_config).
            with_create_ability_check(::Spree::Variant).
            build

          root.add(action)
        end

        def new_variant_config
          {
            icon_name: 'add.svg',
            key: :new_variant,
            url: ->(resource) { new_admin_product_variant_path(resource) },
            classes: 'btn-success',
            id: 'new_var_link',
            data: { update: 'new_variant' }
          }
        end
      end
    end
  end
end
