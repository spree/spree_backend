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
            ActionBuilder.new('new_order', new_admin_order_path).
            with_icon_key('add.svg').
            with_id('admin_new_order').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_create_ability_check(::Spree::Order).
            build

          root.add(action)
        end
      end
    end
  end
end
