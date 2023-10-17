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
            TabBuilder.new(details_config).
            with_active_check.
            with_admin_availability_check(::Spree::Product).
            build

          root.add(tab)
        end

        def details_config
          {
            icon_name: 'edit.svg',
            key: :details,
            url: ->(resource) { edit_admin_product_path(resource) },
            classes: 'nav-link',
            partial_name: :details
          }
        end

        def add_images_tab(root)
          tab =
            TabBuilder.new(images_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Image) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def images_config
          {
            icon_name: 'images.svg',
            key: :images,
            url: ->(resource) { admin_product_images_path(resource) },
            classes: 'nav-link',
            partial_name: :images
          }
        end

        def add_variants_tab(root)
          tab =
            TabBuilder.new(variants_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Variant) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def variants_config
          {
            icon_name: 'adjust.svg',
            key: :variants,
            url: ->(resource) { admin_product_variants_path(resource) },
            classes: 'nav-link',
            partial_name: :variants
          }
        end

        def add_properties_tab(root)
          tab =
            TabBuilder.new(properties_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::ProductProperty) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def properties_config
          {
            icon_name: 'list.svg',
            key: :properties,
            url: ->(resource) { admin_product_product_properties_path(resource) },
            classes: 'nav-link',
            partial_name: :properties
          }
        end

        def add_stock_tab(root)
          tab =
            TabBuilder.new(stock_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::StockItem) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def stock_config
          {
            icon_name: 'box-seam.svg',
            key: :stock,
            url: ->(resource) { stock_admin_product_path(resource) },
            classes: 'nav-link',
            partial_name: :stock
          }
        end

        def add_prices_tab(root)
          tab =
            TabBuilder.new(prices_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Price) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def prices_config
          {
            icon_name: 'currency-exchange.svg',
            key: :prices,
            url: ->(resource) { admin_product_prices_path(resource) },
            classes: 'nav-link',
            partial_name: :prices
          }
        end

        def add_digitals_tab(root)
          tab =
            TabBuilder.new(digitals_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Digital) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def digitals_config
          {
            icon_name: 'download.svg',
            key: 'admin.digitals.digital_assets',
            url: ->(resource) { admin_product_digitals_path(resource) },
            classes: 'nav-link',
            partial_name: :digitals
          }
        end

        def add_translations_tab(root)
          tab =
            TabBuilder.new(translations_config).
            with_active_check.
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:admin, ::Spree::Product) && !resource.deleted?
              end
            ).
            build

          root.add(tab)
        end

        def translations_config
          {
            icon_name: 'translate.svg',
            key: :translations,
            url: ->(resource) { translations_admin_product_path(resource) },
            classes: 'nav-link',
            partial_name: :translations
          }
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
