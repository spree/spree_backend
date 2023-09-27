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
          tab = Tab.new(
            'cart-check.svg',
            :cart,
            ->(resource) { cart_admin_order_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_availability_check(
            # An abstract module should not be aware of resource's internal structure.
            # If these checks are elaborate, it's better to have this complexity declared explicitly here.
            ->(ability, resource) do
              ability.can?(:update, resource) && (resource.shipments.size.zero? || resource.shipments.shipped.size.zero?)
            end
          )

          root.add(tab)
        end

        def add_channel_tab(root)
          tab = Tab.new(
            'funnel.svg',
            :channel,
            ->(resource) { channel_admin_order_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_update_availability_check

          root.add(tab)
        end

        def add_customer_tab(root)
          tab = Tab.new(
            'person-lines-fill.svg',
            :customer,
            ->(resource) { admin_order_customer_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_availability_check(
            ->(ability, resource) do
              ability.can?(:update, resource) && resource.checkout_steps.include?("address")
            end
          )

          root.add(tab)
        end

        def add_shipments_tab(root)
          tab = Tab.new(
            'truck.svg',
            :shipments,
            ->(resource) { edit_admin_order_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_update_availability_check

          root.add(tab)
        end

        def add_adjustments_tab(root)
          tab = Tab.new(
            'adjust.svg',
            :adjustments,
            ->(resource) { admin_order_adjustments_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_index_availability_check(Spree::Adjustment)

          root.add(tab)
        end

        def add_payments_tab(root)
          tab = Tab.new(
            'credit-card.svg',
            :payments,
            ->(resource) { admin_order_payments_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_index_availability_check(Spree::Payment)

          root.add(tab)
        end

        def add_return_authorizations_tab(root)
          tab = Tab.new(
            'enter.svg',
            :return_authorizations,
            ->(resource) { admin_order_return_authorizations_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_index_availability_check(Spree::ReturnAuthorization)

          root.add(tab)
        end

        def add_customer_returns_tab(root)
          tab = Tab.new(
            'returns.svg',
            :customer_returns,
            ->(resource) { admin_order_customer_returns_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_index_availability_check(Spree::CustomerReturn)

          root.add(tab)
        end

        def add_state_changes_tab(root)
          tab = Tab.new(
            'calendar3.svg',
            :state_changes,
            ->(resource) { admin_order_state_changes_url(resource) },
            'nav-link',
          )
          .with_active_check
          .with_update_availability_check

          root.add(tab)
        end
      end
    end
  end
end
