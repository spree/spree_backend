module Spree
  module Admin
    module Actions
      class ActionBuilder
        include ::Spree::Admin::PermissionChecks

        def initialize(config)
          @icon_name =           config[:icon_name]
          @key =                 config[:key]
          @url =                 config[:url]
          @classes =             config[:classes]
          @availability_checks = []
          @method =              config[:method]
          @id =                  config[:id]
          @translation_options = config[:translation_options]
          @target =              config[:target]
          @data =                config[:data]
        end

        def build
          Action.new(build_config)
        end

        private

        def build_config
          {
            icon_name: @icon_name,
            key: @key,
            url: @url,
            classes: @classes,
            availability_checks: @availability_checks,
            text: text(@key, @translation_options),
            method: @method,
            id: @id,
            translation_options: @translation_options,
            target: @target,
            data: @data
          }
        end

        def text(text, options)
          options.present? ? ::Spree.t(text, options) : ::Spree.t(text)
        end
      end
    end
  end
end
