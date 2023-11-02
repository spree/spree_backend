module Spree
  module Admin
    module Actions
      class VariantsDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_new_variant_action(root)
          root
        end

        private

        def add_new_variant_action(root)
          action =
            ActionBuilder.new('new_variant', ->(resource) { new_admin_product_variant_path(resource) }).
            with_icon_key('add.svg').
            with_style(::Spree::Admin::Actions::ActionStyle::PRIMARY).
            with_id('new_var_link').
            with_data_attributes({ update: 'new_variant' }).
            with_create_ability_check(::Spree::Variant).
            build

          root.add(action)
        end
      end
    end
  end
end
