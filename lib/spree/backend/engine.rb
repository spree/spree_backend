require_relative 'configuration'

module Spree
  module Backend
    class Engine < ::Rails::Engine
      Environment = Struct.new(:main_menu, :order_tabs)

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
        Rails.application.config.spree_backend.order_tabs = Spree::Admin::Resources::OrderDefaultTabsBuilder.new.build
      end
    end
  end
end
