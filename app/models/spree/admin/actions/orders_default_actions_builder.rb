module Spree
  module Admin
    module Actions
      class OrdersDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_order_action(root)
          root
        end

        private

        def add_new_order_action(root)
          action =
            ActionBuilder.new(new_order_config).
            with_create_ability_check(::Spree::Order).
            build

          root.add(action)
        end

        def new_order_config
          {
            icon_name: 'add.svg',
            key: :new_order,
            url: new_admin_order_path,
            classes: 'btn-success',
            id: 'admin_new_order'
          }
        end
      end
    end
  end
end
