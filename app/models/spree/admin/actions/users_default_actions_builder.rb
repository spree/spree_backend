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
            ActionBuilder.new(new_user_config).
            with_create_availability_check(::Spree.user_class).
            build

          root.add(action)
        end

        def new_user_config
          {
            icon_name: 'add.svg',
            name: :new_user,
            url: new_admin_user_path,
            classes: 'btn-success',
            id: 'admin_new_user_link'
          }
        end
      end
    end
  end
end
