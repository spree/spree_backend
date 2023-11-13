module Spree
  module Admin
    module Actions
      class PromotionBatchDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          export_codes_to_csv_action(root)
          root
        end

        private

        def export_codes_to_csv_action(root)
          action =
            ActionBuilder.new('csv_export', ->(resource) { csv_export_admin_promotion_batch_path(resource) }).
            with_icon_key('download.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            build

          root.add(action)
        end
      end
    end
  end
end
