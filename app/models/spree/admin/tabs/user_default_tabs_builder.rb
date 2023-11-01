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
            TabBuilder.new('account', ->(resource) { edit_admin_user_path(resource) }).
            with_label_translation_key('admin.user.account').
            with_icon_key('person.svg').
            with_active_check.
            build

          root.add(tab)
        end

        def add_addresses_tab(root)
          tab =
            TabBuilder.new('addresses', ->(resource) { addresses_admin_user_path(resource) }).
            with_label_translation_key('admin.user.addresses').
            with_icon_key('pin-map.svg').
            with_partial_name('address').
            with_active_check.
            build

          root.add(tab)
        end

        def add_orders_tab(root)
          tab =
            TabBuilder.new('orders', ->(resource) { orders_admin_user_path(resource) }).
            with_label_translation_key('admin.user.orders').
            with_icon_key('inbox.svg').
            with_active_check.
            build

          root.add(tab)
        end

        def add_items_tab(root)
          tab =
            TabBuilder.new('items', ->(resource) { items_admin_user_path(resource) }).
            with_label_translation_key('admin.user.items').
            with_icon_key('tag.svg').
            with_active_check.
            build

          root.add(tab)
        end

        def add_store_credits_tab(root)
          tab =
            TabBuilder.new('store_credits', ->(resource) { admin_user_store_credits_path(resource) }).
            with_label_translation_key('admin.user.store_credits').
            with_icon_key('gift.svg').
            with_active_check.
            build

          root.add(tab)
        end
      end
    end
  end
end
