module Spree
  module Admin
    module Actions
      class PaymentsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_payment_action(root)
          root
        end

        private

        def add_new_payment_action(root)
          action =
            ActionBuilder.new(new_payment_config).
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:create, ::Spree::Payment) && resource.outstanding_balance?
              end
            ).
            build

          root.add(action)
        end

        def new_payment_config
          {
            icon_name: 'add.svg',
            key: :new_payment,
            url: ->(resource) { new_admin_order_payment_path(resource) },
            classes: 'btn-success',
            id: 'new_payment_section'
          }
        end
      end
    end
  end
end
