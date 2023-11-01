module Spree
  module Admin
    module Actions
      class ProductsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_product_action(root)
          root
        end

        private

        def add_new_product_action(root)
          action =
            ActionBuilder.new('new_product', new_admin_product_path).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_id('admin_new_product').
            with_create_ability_check(::Spree::Product).
            build

          root.add(action)
        end
      end
    end
  end
end
