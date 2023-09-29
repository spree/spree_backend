module Spree
  module Admin
    module Resources
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
            Tab.new(
              {
                icon_name: 'cart-check.svg',
                name: :cart,
                url: ->(resource) { cart_admin_order_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              # An abstract module should not be aware of resource's internal structure.
              # If these checks are elaborate, it's better to have this complexity declared explicitly here.
              lambda do |ability, resource|
                ability.can?(:update, resource) && (resource.shipments.empty? || resource.shipments.shipped.empty?)
              end
            )

          root.add(tab)
        end

        def add_channel_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'funnel.svg',
                name: :channel,
                url: ->(resource) { channel_admin_order_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_update_availability_check

          root.add(tab)
        end

        def add_customer_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'person-lines-fill.svg',
                name: :customer,
                url: ->(resource) { admin_order_customer_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:update, resource) && resource.checkout_steps.include?('address')
              end
            )

          root.add(tab)
        end

        def add_shipments_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'truck.svg',
                name: :shipments,
                url: ->(resource) { edit_admin_order_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_update_availability_check

          root.add(tab)
        end

        def add_adjustments_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'adjust.svg',
                name: :adjustments,
                url: ->(resource) { admin_order_adjustments_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_index_availability_check(Spree::Adjustment)

          root.add(tab)
        end

        def add_payments_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'credit-card.svg',
                name: :payments,
                url: ->(resource) { admin_order_payments_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_index_availability_check(Spree::Payment)

          root.add(tab)
        end

        def add_return_authorizations_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'enter.svg',
                name: :return_authorizations,
                url: ->(resource) { admin_order_return_authorizations_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_index_availability_check(Spree::ReturnAuthorization)

          root.add(tab)
        end

        def add_customer_returns_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'returns.svg',
                name: :customer_returns,
                url: ->(resource) { admin_order_customer_returns_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_default_translator.
            with_index_availability_check(Spree::CustomerReturn)

          root.add(tab)
        end

        def add_state_changes_tab(root)
          tab =
            Tab.new(
              {
                icon_name: 'calendar3.svg',
                name: :state_changes,
                url: ->(resource) { admin_order_state_changes_path(resource) },
                classes: 'nav-link'
              }
            ).
            with_active_check.
            with_custom_translator(::Spree::StateChange, :human_attribute_name).
            with_update_availability_check

          root.add(tab)
        end
      end
    end
  end
end
