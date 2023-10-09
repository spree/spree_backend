module Spree
  module Admin
    module Actions
      class ProductDefaultActionsBuilder
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
            name: 'admin.utilities.preview',
            url: ->(resource) { spree_storefront_resource_url(resource) },
            classes: 'btn-light',
            id: 'admin_new_product',
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
