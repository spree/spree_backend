module Spree
  module Admin
    module Tabs
      # rubocop:disable Metrics/ClassLength
      class ProductDefaultTabsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_details_tab(root)
          add_images_tab(root)
          add_variants_tab(root)
          add_properties_tab(root)
          add_stock_tab(root)
          add_prices_tab(root)
          add_digitals_tab(root)
          add_translations_tab(root)
          root
        end

        private

        def add_details_tab(root)
          tab =
            TabBuilder.new('details', ->(resource) { edit_admin_product_path(resource) }).
            with_icon_key('edit.svg').
            with_active_check.
            with_admin_ability_check(::Spree::Product).
            build

          root.add(tab)
        end

        def add_images_tab(root)
          tab =
            TabBuilder.new('images', ->(resource) { admin_product_images_path(resource) }).
            with_icon_key('images.svg').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Image) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def add_variants_tab(root)
          tab =
            TabBuilder.new('variants', ->(resource) { admin_product_variants_path(resource) }).
            with_icon_key('adjust.svg').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Variant) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def add_properties_tab(root)
          tab =
            TabBuilder.new('properties', ->(resource) { admin_product_product_properties_path(resource) }).
            with_icon_key('list.svg').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::ProductProperty) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def add_stock_tab(root)
          tab =
            TabBuilder.new('stock', ->(resource) { stock_admin_product_path(resource) }).
            with_icon_key('box-seam.svg').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::StockItem) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def add_prices_tab(root)
          tab =
            TabBuilder.new('prices', ->(resource) { admin_product_prices_path(resource) }).
            with_icon_key('currency-exchange.svg').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Price) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def add_digitals_tab(root)
          tab =
            TabBuilder.new('digital_assets', ->(resource) { admin_product_digitals_path(resource) }).
            with_icon_key('download.svg').
            with_label_translation_key('admin.digitals.digital_assets').
            with_partial_name('digitals').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Digital) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def add_translations_tab(root)
          tab =
            TabBuilder.new('translations', ->(resource) { translations_admin_product_path(resource) }).
            with_icon_key('translate.svg').
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Product) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
