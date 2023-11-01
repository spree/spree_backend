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
            ActionBuilder.new('add_store_credit', ->(resource) { new_admin_user_store_credit_path(resource) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_create_ability_check(::Spree::StoreCredit).
            build

          root.add(action)
        end
      end
    end
  end
end
