module Spree
  module Admin
    module Actions
      class UsersDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_user_action(root)
          root
        end

        private

        def add_new_user_action(root)
          action =
            ActionBuilder.new('new_user', new_admin_user_path).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_id('admin_new_user_link').
            with_create_ability_check(::Spree.user_class).
            build

          root.add(action)
        end
      end
    end
  end
end
