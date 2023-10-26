module Spree
  module Admin
    module Actions
      class StoreCreditsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_add_store_credit_action(root)
          root
        end

        private

        def add_add_store_credit_action(root)
          action =
            ActionBuilder.new(new_user_config).
            with_create_ability_check(::Spree::StoreCredit).
            build

          root.add(action)
        end

        def new_user_config
          {
            icon_name: 'add.svg',
            key: :add_store_credit,
            url: ->(resource) { new_admin_user_store_credit_path(resource) },
            classes: 'btn-success'
          }
        end
      end
    end
  end
end
