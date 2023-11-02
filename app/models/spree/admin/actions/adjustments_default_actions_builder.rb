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
            ActionBuilder.new('new_adjustment', ->(resource) { new_admin_order_adjustment_path(resource) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_create_ability_check(::Spree::Adjustment).
            build

          root.add(action)
        end
      end
    end
  end
end
