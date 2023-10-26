module Spree
  module Admin
    module Actions
      class ProductPreviewActionBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_external_preview_action(root)
          root
        end

        private

        def add_external_preview_action(root)
          action =
            ActionBuilder.new(external_preview_config).
            build

          root.add(action)
        end

        def external_preview_config
          {
            icon_name: 'view.svg',
            key: 'admin.utilities.preview',
            url: ->(resource) { product_path(resource) },
            classes: 'btn-light',
            id: 'adminPreviewProduct',
            translation_options: {
              name: :product
            },
            target: :blank,
            data: { turbo: false }
          }
        end
      end
    end
  end
end