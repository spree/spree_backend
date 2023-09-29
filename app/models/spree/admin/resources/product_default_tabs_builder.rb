module Spree
  module Admin
    module Resources
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
            Tab.new(
              'edit.svg',
              :details,
              ->(resource) { edit_admin_product_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_admin_availability_check(Spree::Product)

          root.add(tab)
        end

        def add_images_tab(root)
          tab =
            Tab.new(
              'images.svg',
              :images,
              ->(resource) { admin_product_images_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::Image) && !resource.deleted?
              end
            )

          root.add(tab)
        end

        def add_variants_tab(root)
          tab =
            Tab.new(
              'adjust.svg',
              :variants,
              ->(resource) { admin_product_variants_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::Variant) && !resource.deleted?
              end
            )

          root.add(tab)
        end

        def add_properties_tab(root)
          tab =
            Tab.new(
              'list.svg',
              :properties,
              ->(resource) { admin_product_product_properties_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::ProductProperty) && !resource.deleted?
              end
            )

          root.add(tab)
        end

        def add_stock_tab(root)
          tab =
            Tab.new(
              'box-seam.svg',
              :stock,
              ->(resource) { stock_admin_product_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::StockItem) && !resource.deleted?
              end
            )

          root.add(tab)
        end

        def add_prices_tab(root)
          tab =
            Tab.new(
              'currency-exchange.svg',
              :prices,
              ->(resource) { admin_product_prices_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::Price) && !resource.deleted?
              end
            )

          root.add(tab)
        end

        def add_digitals_tab(root)
          tab =
            Tab.new(
              'download.svg',
              'admin.digitals.digital_assets',
              ->(resource) { admin_product_digitals_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::Digital) && !resource.deleted?
              end
            )

          root.add(tab)
        end

        def add_translations_tab(root)
          tab =
            Tab.new(
              'translate.svg',
              :translations,
              ->(resource) { translations_admin_product_path(resource) },
              'nav-link'
            ).
            with_active_check.
            with_default_translator.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, Spree::Product) && !resource.deleted?
              end
            )

          root.add(tab)
        end
      end
    end
  end
end
