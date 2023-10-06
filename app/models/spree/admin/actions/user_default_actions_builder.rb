module Spree
  module Admin
    module Actions
      class UserDefaultActionsBuilder
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
            with_create_availability_check(Spree::Order).
            build

          root.add(action)
        end

        def new_order_config
          {
            icon_name: 'add.svg',
            name: :create_new_order,
            url: ->(resource) { new_admin_order_path(user_id: resource.id) },
            classes: 'btn-success',
            method: :post
          }
        end
      end
    end
  end
end
