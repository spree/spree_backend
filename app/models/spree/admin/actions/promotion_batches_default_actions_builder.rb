module Spree
  module Admin
    module Actions
      class PromotionBatchesDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_promotion_batch_action(root)
          root
        end

        private

        def add_new_promotion_batch_action(root)
          action =
            ActionBuilder.new('new_promotion_batch', new_admin_promotion_batch_path).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_create_ability_check(::Spree::PromotionBatch).
            build

          root.add(action)
        end
      end
    end
  end
end
