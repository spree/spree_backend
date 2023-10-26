module Spree
  module Admin
    module Actions
      class AdjustmentsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_adjustment_action(root)
          root
        end

        private

        def add_new_adjustment_action(root)
          action =
            ActionBuilder.new(new_adjustment_config).
            with_create_ability_check(::Spree::Adjustment).
            build

          root.add(action)
        end

        def new_adjustment_config
          {
            icon_name: 'add.svg',
            key: :new_adjustment,
            url: ->(resource) { new_admin_order_adjustment_path(resource) },
            classes: 'btn-success'
          }
        end
      end
    end
  end
end
