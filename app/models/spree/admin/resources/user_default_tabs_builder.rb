module Spree
  module Admin
    module Resources
      class UserDefaultTabsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_account_tab(root)
          add_addresses_tab(root)
          add_orders_tab(root)
          add_items_tab(root)
          add_store_credits_tab(root)
          root
        end

        private

        def add_account_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'person.svg',
                name: 'admin.user.account',
                url: ->(resource) { edit_admin_user_path(resource) },
                classes: 'nav-link',
                partial_name: :account
              }
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_addresses_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'pin-map.svg',
                name: 'admin.user.addresses',
                url: ->(resource) { addresses_admin_user_path(resource) },
                classes: 'nav-link',
                partial_name: :address
              }
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_orders_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'inbox.svg',
                name: 'admin.user.orders',
                url: ->(resource) { orders_admin_user_path(resource) },
                classes: 'nav-link',
                partial_name: :orders
              }
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_items_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'tag.svg',
                name: 'admin.user.items',
                url: ->(resource) { items_admin_user_path(resource) },
                classes: 'nav-link',
                partial_name: :items
              }
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_store_credits_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'gift.svg',
                name: 'admin.user.store_credits',
                url: ->(resource) { admin_user_store_credits_path(resource) },
                classes: 'nav-link',
                partial_name: :store_credits
              }
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end
      end
    end
  end
end
