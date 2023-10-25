module Spree
  module Admin
    module Actions
      class ImagesDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_image_action(root)
          root
        end

        private

        def add_new_image_action(root)
          action =
            ActionBuilder.new(new_image_config).
            with_create_ability_check(::Spree::Image).
            build

          root.add(action)
        end

        def new_image_config
          {
            icon_name: 'add.svg',
            key: :new_image,
            url: ->(resource) { new_admin_product_image_path(resource) },
            classes: 'btn-success',
            id: 'new_image_link'
          }
        end
      end
    end
  end
end
