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
            TabBuilder.new('cart', ->(resource) { cart_admin_order_path(resource) }).
            with_icon_key('cart-check.svg').
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

        def add_channel_tab(root)
          tab =
            TabBuilder.new('channel', ->(resource) { channel_admin_order_path(resource) }).
            with_icon_key('funnel.svg').
            with_active_check.
            with_update_ability_check.
            with_data_hook('admin_order_tabs_channel_details').
            build

          root.add(tab)
        end

        def add_customer_tab(root)
          tab =
            TabBuilder.new('customer', ->(resource) { admin_order_customer_path(resource) }).
            with_icon_key('person-lines-fill.svg').
            with_partial_name('customer_details').
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

        def add_shipments_tab(root)
          tab =
            TabBuilder.new('shipments', ->(resource) { edit_admin_order_path(resource) }).
            with_icon_key('truck.svg').
            with_active_check.
            with_update_ability_check.
            with_data_hook('admin_order_tabs_shipment_details').
            build

          root.add(tab)
        end

        def add_adjustments_tab(root)
          tab =
            TabBuilder.new('adjustments', ->(resource) { admin_order_adjustments_path(resource) }).
            with_icon_key('adjust.svg').
            with_active_check.
            with_index_ability_check(::Spree::Adjustment).
            with_data_hook('admin_order_tabs_adjustments').
            build

          root.add(tab)
        end

        def add_payments_tab(root)
          tab =
            TabBuilder.new('payments', ->(resource) { admin_order_payments_path(resource) }).
            with_icon_key('credit-card.svg').
            with_active_check.
            with_index_ability_check(::Spree::Payment).
            with_data_hook('admin_order_tabs_payments').
            build

          root.add(tab)
        end

        def add_return_authorizations_tab(root)
          tab =
            TabBuilder.new('return_authorizations', ->(resource) { admin_order_return_authorizations_path(resource) }).
            with_icon_key('enter.svg').
            with_active_check.
            with_completed_check.
            with_index_ability_check(::Spree::ReturnAuthorization).
            with_data_hook('admin_order_tabs_return_authorizations').
            build

          root.add(tab)
        end

        def add_customer_returns_tab(root)
          tab =
            TabBuilder.new('customer_returns', ->(resource) { admin_order_customer_returns_path(resource) }).
            with_icon_key('returns.svg').
            with_active_check.
            with_completed_check.
            with_index_ability_check(::Spree::CustomerReturn).
            build

          root.add(tab)
        end

        def add_state_changes_tab(root)
          tab =
            TabBuilder.new('state_changes', ->(resource) { admin_order_state_changes_path(resource) }).
            with_icon_key('calendar3.svg').
            with_active_check.
            with_update_ability_check.
            with_data_hook('admin_order_tabs_state_changes').
            build

          root.add(tab)
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
