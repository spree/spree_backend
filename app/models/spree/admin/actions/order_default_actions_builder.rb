module Spree
  module Admin
    module Actions
      class OrderDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_resend_action(root)
          root
        end

        private

        def add_resend_action(root)
          action =
            ActionBuilder.new(resend_config).
            with_resend_availability_check.
            build

          root.add(action)
        end

        def resend_config
          {
            icon_name: 'envelope.svg',
            name: :resend,
            url: ->(resource) { resend_admin_order_path(resource) },
            classes: 'btn-secondary',
            method: :post
          }
        end
      end
    end
  end
end
