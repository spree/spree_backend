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
              'person.svg',
              :"admin.user.account",
              ->(resource) { edit_admin_user_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_addresses_tab(root)
          tab =
            Tab.new(
              'pin-map.svg',
              :"admin.user.addresses",
              ->(resource) { addresses_admin_user_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_orders_tab(root)
          tab =
            Tab.new(
              'inbox.svg',
              :"admin.user.orders",
              ->(resource) { orders_admin_user_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_items_tab(root)
          tab =
            Tab.new(
              'tag.svg',
              :"admin.user.items",
              ->(resource) { items_admin_user_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end

        def add_store_credits_tab(root)
          tab =
            Tab.new(
              'gift.svg',
              :"admin.user.store_credits",
              ->(resource) { admin_user_store_credits_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator

          root.add(tab)
        end
      end
    end
  end
end
