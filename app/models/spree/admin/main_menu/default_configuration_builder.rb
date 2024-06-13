module Spree
  module Admin
    module MainMenu
      # rubocop:disable Metrics/ClassLength
      class DefaultConfigurationBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_dashboard_item(root)
          add_orders_section(root)
          add_returns_section(root)
          add_products_section(root)
          add_stocks_section(root)
          add_reports_item(root)
          add_promotions_section(root)
          add_users_item(root)
          add_content_section(root)
          add_integrations_section(root)
          add_oauth_section(root)
          add_settings_section(root)
          root
        end

        private

        def add_dashboard_item(root)
          root.add(ItemBuilder.new('dashboard', admin_dashboard_path).
            with_label_translation_key('admin.home').
            with_icon_key('house-door-fill.svg').
            with_match_path('/dashboard').
            build)
        end

        def add_orders_section(root)
          items = [
            ItemBuilder.new('completed', admin_orders_path(q: { completed_at_not_null: '1' })).
              with_label_translation_key('admin.orders.all_orders').
              with_match_path(/completed_at_not_null%5D=1/).
              build,
            ItemBuilder.new('draft_orders', admin_orders_path(q: { completed_at_not_null: false, state_eq: :cart })).
              with_label_translation_key('admin.orders.draft_orders').
              with_match_path(/cart/).
              build,
            ItemBuilder.new('abandoned_checkouts', admin_orders_path(
                                                     q: { completed_at_not_null: false, state_in: %i[address delivery payment confirm] }
                                                   )).
              with_label_translation_key('admin.orders.abandoned_checkouts').
              with_match_path(/state_in/).
              build
          ]

          section = SectionBuilder.new('orders', 'inbox-fill.svg').
                    with_admin_ability_check(Spree::Order).
                    with_items(items).
                    build
          root.add(section)
        end

        def add_returns_section(root)
          items = [
            ItemBuilder.new('return_authorizations', admin_return_authorizations_path).
              with_manage_ability_check(Spree::ReturnAuthorization).
              with_match_path('/return_authorizations').
              build,
            ItemBuilder.new('customer_returns', admin_customer_returns_path).
              with_manage_ability_check(Spree::CustomerReturn).
              with_match_path('/customer_returns').
              build
          ]

          section = SectionBuilder.new('returns', 'reply-fill.svg').
                    with_manage_ability_check(Spree::ReturnAuthorization, Spree::CustomerReturn).
                    with_items(items).
                    build
          root.add(section)
        end

        def add_products_section(root)
          items = [
            ItemBuilder.new('products', admin_products_path).with_match_path('/products').build,
            ItemBuilder.new('option_types', admin_option_types_path).
              with_admin_ability_check(Spree::OptionType).
              with_match_path('/option_types').
              build,
            ItemBuilder.new('properties', admin_properties_path).
              with_admin_ability_check(Spree::Property).
              with_match_path('/properties').
              build,
            ItemBuilder.new('prototypes', admin_prototypes_path).
              with_admin_ability_check(Spree::Prototype).
              with_match_path('/prototypes').
              build,
            ItemBuilder.new('taxonomies', admin_taxonomies_path).
              with_admin_ability_check(Spree::Taxonomy).
              with_match_path('/taxonomies').
              build,
            ItemBuilder.new('taxons', admin_taxons_path).
              with_admin_ability_check(Spree::Taxon).
              with_match_path('/taxons').
              build
          ]

          section = SectionBuilder.new('products', 'tags-fill.svg').
                    with_admin_ability_check(Spree::Product).
                    with_items(items).
                    build
          root.add(section)
        end

        def add_stocks_section(root)
          items = [
            ItemBuilder.new('stock_transfers', admin_stock_transfers_path).
              with_manage_ability_check(Spree::StockTransfer).
              with_match_path('/stock_transfers').
              build,
            ItemBuilder.new('stock_locations', admin_stock_locations_path).
              with_manage_ability_check(Spree::StockLocation).
              with_match_path('/stock_locations').
              build
          ]

          section = SectionBuilder.new('stocks', 'box-seam.svg').
                    with_manage_ability_check(Spree::StockLocation, Spree::StockTransfer).
                    with_label_translation_key('admin.tab.stock').
                    with_items(items).
                    build
          root.add(section)
        end

        def add_reports_item(root)
          root.add(ItemBuilder.new('reports', admin_reports_path).
            with_icon_key('pie-chart-fill.svg').
            with_admin_ability_check(Spree::Admin::ReportsController).
            build)
        end

        def add_promotions_section(root)
          items = [
            ItemBuilder.new('promotions', admin_promotions_path).
            with_admin_ability_check(Spree::Promotion).
            with_match_path('/promotions').
            build,
            ItemBuilder.new('promotion_categories', admin_promotion_categories_path).
              with_admin_ability_check(Spree::PromotionCategory).
              with_label_translation_key('admin.tab.promotion_categories').
              with_match_path('/promotion_categories').
              build
          ]

          section = SectionBuilder.new('promotions', 'percent.svg').
                    with_admin_ability_check(Spree::Promotion).
                    with_items(items).
                    build
          root.add(section)
        end

        def add_users_item(root)
          root.add(ItemBuilder.new('users', admin_users_path).
            with_icon_key('people-fill.svg').
            with_availability_check(->(ability, _store) { Spree.user_class && ability.can?(:admin, Spree.user_class) }).
            build)
        end

        def add_content_section(root)
          items = [
            ItemBuilder.new('menus', admin_menus_path).
              with_label_translation_key('admin.tab.navigation').
              with_admin_ability_check(Spree::Menu).
              with_match_path('/menus').
              build,
            ItemBuilder.new('cms_pages', admin_cms_pages_path).
              with_label_translation_key('admin.tab.pages').
              with_admin_ability_check(Spree::CmsPage).
              with_match_path('/cms_pages').
              build
          ]

          section = SectionBuilder.new('content', 'card-heading.svg').
                    with_admin_ability_check(Spree::Menu).
                    with_label_translation_key('admin.tab.content').
                    with_items(items).
                    build
          root.add(section)
        end

        def add_integrations_section(root)
          items = [
            ItemBuilder.new('payment_methods', admin_payment_methods_path).
              with_manage_ability_check(Spree::PaymentMethod).
              with_match_path('/payment_methods').
              build,
            ItemBuilder.new('data_feeds', admin_data_feeds_path).
              with_manage_ability_check(Spree::DataFeed).
              with_label_translation_key('admin.data_feeds.data_feeds').
              with_match_path('/data_feeds').
              build,
            ItemBuilder.new('webhook_subscribers', admin_webhooks_subscribers_path).
              with_manage_ability_check(Spree::Webhooks::Subscriber).
              with_label_translation_key('admin.tab.webhook_subscribers').
              with_match_path('/webhooks_subscribers').
              build
          ]

          section = SectionBuilder.new('integrations', 'stack.svg').
                    with_manage_ability_check(Spree::Webhooks::Subscriber, Spree::PaymentMethod, Spree::DataFeed).
                    with_label_translation_key('admin.tab.integrations').
                    with_items(items).
                    build
          root.add(section)
        end

        def add_oauth_section(root)
          section = SectionBuilder.new('oauth', 'terminal-fill.svg').
                    with_admin_ability_check(Spree::OauthApplication).
                    with_label_translation_key('admin.tab.apps').
                    with_item(ItemBuilder.new('oauth_applications', admin_oauth_applications_path).
              with_label_translation_key('admin.oauth_applications.list').
              with_match_path('/oauth_applications').
              build).
                    build
          root.add(section)
        end

        # rubocop:disable Metrics/AbcSize
        def add_settings_section(root)
          items = [
            ItemBuilder.new('store', ->(store) { edit_admin_store_path(store) }).
              with_match_path(/\/admin\/stores\//).
              build,
            ItemBuilder.new('tax_categories', admin_tax_categories_path).
              with_match_path('/tax_categories').
              with_manage_ability_check(Spree::TaxCategory).
              build,
            ItemBuilder.new('tax_rates', admin_tax_rates_path).with_manage_ability_check(Spree::TaxRate).
              with_match_path('/tax_rates').
              build,
            ItemBuilder.new('zones', admin_zones_path).with_manage_ability_check(Spree::Zone).
              with_match_path('/zones').
              build,
            ItemBuilder.new('country', admin_countries_path).with_manage_ability_check(Spree::Country).
              with_match_path(%r{^/admin/countries$}).
              build,
            ItemBuilder.new('states', ->(store) { admin_country_states_path(store.default_country) }).
              with_match_path(/states/).
              with_manage_ability_check(->(ability, store) { store.default_country && ability.can?(:manage, Spree::Country) }).
              build,
            ItemBuilder.new('shipping_methods', admin_shipping_methods_path).
              with_match_path('/shipping_methods').
              with_manage_ability_check(Spree::ShippingMethod).
              build,
            ItemBuilder.new('shipping_categories', admin_shipping_categories_path).
              with_match_path('/shipping_categories').
              with_manage_ability_check(Spree::ShippingCategory).
              build,
            ItemBuilder.new('store_credit_categories', admin_store_credit_categories_path).
              with_match_path('/store_credit_categories').
              with_manage_ability_check(Spree::StoreCreditCategory).
              build,
            ItemBuilder.new('refund_reasons', admin_refund_reasons_path).
              with_match_path('/refund_reasons').
              with_manage_ability_check(Spree::RefundReason).
              build,
            ItemBuilder.new('reimbursement_types', admin_reimbursement_types_path).
              with_match_path('/reimbursement_types').
              with_manage_ability_check(Spree::ReimbursementType).
              build,
            ItemBuilder.new('return_authorization_reasons', admin_return_authorization_reasons_path).
              with_match_path('/return_authorization_reasons').
              with_manage_ability_check(Spree::ReturnAuthorizationReason).
              build,
            ItemBuilder.new('roles', admin_roles_path).with_manage_ability_check(Spree::Role).
              with_match_path('/roles').
              build
          ]

          section = SectionBuilder.new('settings', 'gear-fill.svg').
                    with_availability_check(->(ability, store) { ability.can?(:manage, store) }).
                    with_label_translation_key('admin.settings').
                    with_items(items).
                    build
          root.add(section)
        end
        # rubocop:enable Metrics/AbcSize
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
