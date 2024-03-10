require_relative 'configuration'
require_relative 'runtime_configuration'

module Spree
  module Backend
    class Engine < ::Rails::Engine
      Environment = Struct.new(:main_menu, :tabs, :actions)

      config.middleware.use 'Spree::Backend::Middleware::SeoAssist'

      initializer 'spree.backend.environment', before: :load_config_initializers do |app|
        Spree::Backend::Config = Spree::Backend::Configuration.new
        Spree::Backend::RuntimeConfig = Spree::Backend::RuntimeConfiguration.new
        app.config.spree_backend = Environment.new
      end

      initializer "spree.backend.assets" do |app|
        app.config.assets.paths << root.join("app/javascript")
        app.config.assets.precompile += %w[ spree_backend_manifest ]
      end

      initializer 'spree.backend.importmap', before: 'importmap' do |app|
        app.config.importmap.paths << root.join('config/importmap.rb')
        # https://github.com/rails/importmap-rails?tab=readme-ov-file#sweeping-the-cache-in-development-and-test
        app.config.importmap.cache_sweepers << root.join('app/javascript')
      end

      # filter sensitive information during logging
      initializer 'spree.params.filter' do |app|
        app.config.filter_parameters += [:password, :password_confirmation, :number]
      end

      initializer 'spree.backend.checking_deprecated_preferences' do
        Spree::Backend::Config.deprecated_preferences.each do |pref|
          # FIXME: we should only notify about deprecated preferences that are in use, not all of them
          # warn "[DEPRECATION] Spree::Backend::Config[:#{pref[:name]}] is deprecated. #{pref[:message]}"
        end
      end

      config.after_initialize do
        Rails.application.reload_routes!
        Rails.application.config.spree_backend.main_menu = Spree::Admin::MainMenu::DefaultConfigurationBuilder.new.build
        Rails.application.config.spree_backend.tabs = {}
        Rails.application.config.spree_backend.tabs[:order] = Spree::Admin::Tabs::OrderDefaultTabsBuilder.new.build
        Rails.application.config.spree_backend.tabs[:user] = Spree::Admin::Tabs::UserDefaultTabsBuilder.new.build
        Rails.application.config.spree_backend.tabs[:product] = Spree::Admin::Tabs::ProductDefaultTabsBuilder.new.build
        Rails.application.config.spree_backend.actions = {}
        Rails.application.config.spree_backend.actions[:orders] = Spree::Admin::Actions::OrdersDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:order] = Spree::Admin::Actions::OrderDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:users] = Spree::Admin::Actions::UsersDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:user] = Spree::Admin::Actions::UserDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:products] = Spree::Admin::Actions::ProductsDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:product] = Spree::Admin::Actions::Root.new
        Rails.application.config.spree_backend.actions[:stock] = Spree::Admin::Actions::Root.new
        Rails.application.config.spree_backend.actions[:prices] = Spree::Admin::Actions::Root.new
        Rails.application.config.spree_backend.actions[:images] = Spree::Admin::Actions::ImagesDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:store_credits] = Spree::Admin::Actions::StoreCreditsDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:adjustments] = Spree::Admin::Actions::AdjustmentsDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:payments] = Spree::Admin::Actions::PaymentsDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:variants] = Spree::Admin::Actions::VariantsDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:product_properties] = Spree::Admin::Actions::ProductPropertiesDefaultActionsBuilder.new.build
      end
    end
  end
end
