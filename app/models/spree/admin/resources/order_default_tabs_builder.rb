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
        end

        private

        def add_cart_tab(root)
          Tab.new(
            'cart-check.svg',
            :cart,
            ->(resource) { cart_admin_order_url(resource) },
            :cart,
            'nav-link',
          )
          .with_active_check
          .with_update_availability_check
        end

        def add_channel_tab(root)
        end

        def add_customer_tab(root)
        end

        def add_shipments_tab(root)
        end

        def add_adjustments_tab(root)
        end

        def add_payments_tab(root)
        end

        def add_return_authorizations_tab(root)
        end

        def add_customer_returns_tab(root)
        end

        def add_state_changes_tab(root)
        end

      end
    end
  end
end
