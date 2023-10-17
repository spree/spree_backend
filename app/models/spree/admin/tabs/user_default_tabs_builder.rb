module Spree
  module Admin
    module Tabs
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
            TabBuilder.new(account_config).
            with_active_check.
            build

          root.add(tab)
        end

        def account_config
          {
            icon_name: 'person.svg',
            key: 'admin.user.account',
            url: ->(resource) { edit_admin_user_path(resource) },
            classes: 'nav-link',
            partial_name: :account
          }
        end

        def add_addresses_tab(root)
          tab =
            TabBuilder.new(addresses_config).
            with_active_check.
            build

          root.add(tab)
        end

        def addresses_config
          {
            icon_name: 'pin-map.svg',
            key: 'admin.user.addresses',
            url: ->(resource) { addresses_admin_user_path(resource) },
            classes: 'nav-link',
            partial_name: :address
          }
        end

        def add_orders_tab(root)
          tab =
            TabBuilder.new(orders_config).
            with_active_check.
            build

          root.add(tab)
        end

        def orders_config
          {
            icon_name: 'inbox.svg',
            key: 'admin.user.orders',
            url: ->(resource) { orders_admin_user_path(resource) },
            classes: 'nav-link',
            partial_name: :orders
          }
        end

        def add_items_tab(root)
          tab =
            TabBuilder.new(items_config).
            with_active_check.
            build

          root.add(tab)
        end

        def items_config
          {
            icon_name: 'tag.svg',
            key: 'admin.user.items',
            url: ->(resource) { items_admin_user_path(resource) },
            classes: 'nav-link',
            partial_name: :items
          }
        end

        def add_store_credits_tab(root)
          tab =
            TabBuilder.new(store_credits_config).
            with_active_check.
            build

          root.add(tab)
        end

        def store_credits_config
          {
            icon_name: 'gift.svg',
            key: 'admin.user.store_credits',
            url: ->(resource) { admin_user_store_credits_path(resource) },
            classes: 'nav-link',
            partial_name: :store_credits
          }
        end
      end
    end
  end
end
