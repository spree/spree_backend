module Spree
  module Admin
    module Actions
      class PromotionBatchesDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_view_promotions_action(root)
          add_import_promotion_batch_action(root)
          add_generate_promotion_batch_action(root)
          root
        end

        private

        def add_generate_promotion_batch_action(root)
          action =
            ActionBuilder.new('generate_codes', ->(template_promotion) { new_admin_template_promotion_promotion_batch_path(template_promotion_id: template_promotion.id) }).
            with_label_translation_key('admin.promotion_batches.generate_codes').
            with_icon_key('add.svg').
            with_style(Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_create_ability_check(Spree::PromotionBatch).
            build

          root.add(action)
        end

        def add_import_promotion_batch_action(root)
          action =
            ActionBuilder.new('import_csv', ->(template_promotion) { import_admin_template_promotion_promotion_batches_path(template_promotion_id: template_promotion.id) }).
              with_label_translation_key('admin.promotion_batches.import_csv').
              with_icon_key('file-earmark-arrow-up.svg').
              with_style(Spree::Admin::Actions::ActionStyle::LIGHT).
              with_create_ability_check(Spree::PromotionBatch).
              build

          root.add(action)
        end

        def add_view_promotions_action(root)
          action =
            ActionBuilder.new('view_promotions', ->(template_promotion) { admin_promotions_path(q: { for_template_promotion_id: template_promotion.id }) }).
              with_label_translation_key('admin.promotion_batches.view_promotions').
              with_icon_key('list.svg').
              with_style(Spree::Admin::Actions::ActionStyle::LIGHT).
              with_manage_ability_check(Spree::Promotion).
              build

          root.add(action)
        end
      end
    end
  end
end
