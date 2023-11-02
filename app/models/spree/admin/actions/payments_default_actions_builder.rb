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
            ActionBuilder.new('new_payment', ->(resource) { new_admin_order_payment_path(resource) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_id('new_payment_section').
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:create, ::Spree::Payment) && resource.outstanding_balance?
              end
            ).
            build

          root.add(action)
        end
      end
    end
  end
end
