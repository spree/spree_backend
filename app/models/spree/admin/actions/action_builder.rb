module Spree
  module Admin
    module Actions
      class ActionBuilder
        include ::Spree::Admin::PermissionChecks

        def initialize(key, url)
          @key = key
          @label_translation_key = key
          @url = url
          @icon_key = nil
          @style = ::Spree::Admin::Actions::ActionStyle::LIGHT
          @availability_checks = []
          @classes = ''
          @method = nil
          @id = nil
          @target = nil
          @data_attributes = {}
        end

        def with_label_translation_key(key)
          @label_translation_key = key
          self
        end

        def with_icon_key(icon_key)
          @icon_key = icon_key
          self
        end

        def with_classes(classes)
          @classes = classes
          self
        end

        def with_style(style)
          @style = style
          self
        end

        def with_method(method)
          @method = method
          self
        end

        def with_id(id)
          @id = id
          self
        end

        def with_target(target)
          @target = target
          self
        end

        def with_data_attributes(data_attributes)
          @data_attributes = data_attributes
          self
        end

        def build
          Action.new(
            @key,
            @label_translation_key,
            @url,
            @icon_key,
            @style,
            @availability_checks,
            @classes,
            @method,
            @id,
            @target,
            @data_attributes
          )
        end
      end
    end
  end
end
