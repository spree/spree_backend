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
            ActionBuilder.new('create_new_order', ->(resource) { new_admin_order_path(user_id: resource.id) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_method(:post).
            with_create_ability_check(Spree::Order).
            build

          root.add(action)
        end
      end
    end
  end
end
