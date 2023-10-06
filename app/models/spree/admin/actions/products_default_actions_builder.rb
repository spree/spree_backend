module Spree
  module Admin
    module Actions
      class ProductsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_product_action(root)
          root
        end

        private

        def add_new_product_action(root)
          action =
            ActionBuilder.new(new_product_config).
            with_create_availability_check(::Spree::Product).
            build

          root.add(action)
        end

        def new_product_config
          {
            icon_name: 'add.svg',
            name: :new_product,
            url: new_admin_product_path,
            classes: 'btn-success',
            id: 'admin_new_product'
          }
        end
      end
    end
  end
end
