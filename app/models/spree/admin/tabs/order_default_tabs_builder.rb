module Spree
  module Admin
    module Tabs
      # rubocop:disable Metrics/ClassLength
      class OrderDefaultTabsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_cart_tab(root)
          add_channel_tab(root)
          add_customer_tab(root)
          add_shipments_tab(root)
          add_adjustments_tab(root)
          add_payments_tab(root)
          add_return_authorizations_tab(root)
          add_customer_returns_tab(root)
          add_state_changes_tab(root)
          root
        end

        private

        def add_cart_tab(root)
          tab =
            TabBuilder.new(cart_tab_config).
            with_active_check.
            with_availability_check(
              # An abstract module should not be aware of resource's internal structure.
              # If these checks are elaborate, it's better to have this complexity declared explicitly here.
              lambda do |ability, resource|
                ability.can?(:update, resource) && (resource.shipments.empty? || resource.shipments.shipped.empty?)
              end
            ).
            with_data_hook('admin_order_tabs_cart_details').
            build

          root.add(tab)
        end

        def cart_tab_config
          {
            icon_name: 'cart-check.svg',
            name: :cart,
            url: ->(resource) { cart_admin_order_path(resource) },
            classes: 'nav-link',
            partial_name: :cart
          }
        end

        def add_channel_tab(root)
          tab =
            TabBuilder.new(channel_tab_config).
            with_active_check.
            with_update_availability_check.
            with_data_hook('admin_order_tabs_channel_details').
            build

          root.add(tab)
        end

        def channel_tab_config
          {
            icon_name: 'funnel.svg',
            name: :channel,
            url: ->(resource) { channel_admin_order_path(resource) },
            classes: 'nav-link',
            partial_name: :channel
          }
        end

        def add_customer_tab(root)
          tab =
            TabBuilder.new(customer_tab_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:update, resource) && resource.checkout_steps.include?('address')
              end
            ).
            with_data_hook('admin_order_tabs_customer_details').
            build

          root.add(tab)
        end

        def customer_tab_config
          {
            icon_name: 'person-lines-fill.svg',
            name: :customer,
            url: ->(resource) { admin_order_customer_path(resource) },
            classes: 'nav-link',
            partial_name: :customer_details
          }
        end

        def add_shipments_tab(root)
          tab =
            TabBuilder.new(shipments_tab_config).
            with_active_check.
            with_update_availability_check.
            with_data_hook('admin_order_tabs_shipment_details').
            build

          root.add(tab)
        end

        def shipments_tab_config
          {
            icon_name: 'truck.svg',
            name: :shipments,
            url: ->(resource) { edit_admin_order_path(resource) },
            classes: 'nav-link',
            partial_name: :shipments
          }
        end

        def add_adjustments_tab(root)
          tab =
            TabBuilder.new(adjustments_tab_config).
            with_active_check.
            with_index_availability_check(::Spree::Adjustment).
            with_data_hook('admin_order_tabs_adjustments').
            build

          root.add(tab)
        end

        def adjustments_tab_config
          {
            icon_name: 'adjust.svg',
            name: :adjustments,
            url: ->(resource) { admin_order_adjustments_path(resource) },
            classes: 'nav-link',
            partial_name: :adjustments
          }
        end

        def add_payments_tab(root)
          tab =
            TabBuilder.new(payments_tab_config).
            with_active_check.
            with_index_availability_check(::Spree::Payment).
            with_data_hook('admin_order_tabs_payments').
            build

          root.add(tab)
        end

        def payments_tab_config
          {
            icon_name: 'credit-card.svg',
            name: :payments,
            url: ->(resource) { admin_order_payments_path(resource) },
            classes: 'nav-link',
            partial_name: :payments
          }
        end

        def add_return_authorizations_tab(root)
          tab =
            TabBuilder.new(return_authorizations_tab_config).
            with_active_check.
            with_completed_check.
            with_index_availability_check(::Spree::ReturnAuthorization).
            with_data_hook('admin_order_tabs_return_authorizations').
            build

          root.add(tab)
        end

        def return_authorizations_tab_config
          {
            icon_name: 'enter.svg',
            name: :return_authorizations,
            url: ->(resource) { admin_order_return_authorizations_path(resource) },
            classes: 'nav-link',
            partial_name: :return_authorizations
          }
        end

        def add_customer_returns_tab(root)
          tab =
            TabBuilder.new(customer_returns_tab_config).
            with_active_check.
            with_completed_check.
            with_index_availability_check(::Spree::CustomerReturn).
            build

          root.add(tab)
        end

        def customer_returns_tab_config
          {
            icon_name: 'returns.svg',
            name: :customer_returns,
            url: ->(resource) { admin_order_customer_returns_path(resource) },
            classes: 'nav-link',
            partial_name: :customer_returns
          }
        end

        def add_state_changes_tab(root)
          tab =
            TabBuilder.new(state_changes_tab_config).
            with_active_check.
            with_update_availability_check.
            with_data_hook('admin_order_tabs_state_changes').
            build

          root.add(tab)
        end

        def state_changes_tab_config
          {
            icon_name: 'calendar3.svg',
            name: :state_changes,
            url: ->(resource) { admin_order_state_changes_path(resource) },
            classes: 'nav-link',
            partial_name: :state_changes
          }
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
