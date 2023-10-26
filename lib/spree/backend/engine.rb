require_relative 'configuration'

module Spree
  module Backend
    class Engine < ::Rails::Engine
      Environment = Struct.new(:main_menu, :tabs, :actions)

      config.middleware.use 'Spree::Backend::Middleware::SeoAssist'

      initializer 'spree.backend.environment', before: :load_config_initializers do |app|
        Spree::Backend::Config = Spree::Backend::Configuration.new
        app.config.spree_backend = Environment.new
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
        Rails.application.config.spree_backend.actions.include?(:images) ? (Rails.application.config.spree_backend.actions[:images].items << Spree::Admin::Actions::ImagesDefaultActionsBuilder.new.build.items).flatten! : Rails.application.config.spree_backend.actions[:images] = Spree::Admin::Actions::ImagesDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:store_credits] = Spree::Admin::Actions::StoreCreditsDefaultActionsBuilder.new.build
        Rails.application.config.spree_backend.actions[:adjustments] = Spree::Admin::Actions::AdjustmentsDefaultActionsBuilder.new.build
      end
    end
  end
end
