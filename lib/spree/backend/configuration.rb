module Spree
  module Backend
    class Configuration < Preferences::Configuration
      preference :admin_products_per_page, :integer, default: Kaminari.config.default_per_page
      preference :admin_orders_per_page, :integer, default: Kaminari.config.default_per_page
      preference :admin_properties_per_page, :integer, default: Kaminari.config.default_per_page
      preference :admin_promotions_per_page, :integer, default: Kaminari.config.default_per_page
      preference :admin_customer_returns_per_page, :integer, default: Kaminari.config.default_per_page
      preference :admin_users_per_page, :integer, default: Kaminari.config.default_per_page
      preference :locale, :string
      preference :variants_per_page, :integer, default: Kaminari.config.default_per_page
      preference :menus_per_page, :integer, default: Kaminari.config.default_per_page
      preference :product_wysiwyg_editor_enabled, :boolean, default: true
      preference :taxon_wysiwyg_editor_enabled, :boolean, default: true
      preference :show_only_complete_orders_by_default, :boolean, default: true
    end
  end
end
