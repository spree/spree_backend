module Spree
  module Admin
    module Actions
      class Action
        STYLE_CLASSES = {
          ::Spree::Admin::Actions::ActionStyle::PRIMARY => 'btn-primary',
          ::Spree::Admin::Actions::ActionStyle::SECONDARY => 'btn-secondary',
          ::Spree::Admin::Actions::ActionStyle::LIGHT => 'btn-light'
        }

        attr_reader :key, :label_translation_key, :icon_key, :method, :id, :target, :data_attributes

        def initialize(key, label_translation_key, url, icon_key, style, availability_checks, additional_classes, method, id, target, data_attributes) # rubocop:disable Metrics/ParameterLists
          @key = key
          @label_translation_key = label_translation_key
          @url = url
          @icon_key = icon_key
          @style = style
          @availability_checks = availability_checks
          @additional_classes = additional_classes
          @method = method
          @id = id
          @target = target
          @data_attributes = data_attributes
        end

        def available?(current_ability, resource = nil)
          return true if @availability_checks.empty?

          result = @availability_checks.map { |check| check.call(current_ability, resource) }

          result.all?(true)
        end

        def url(resource = nil)
          @url.is_a?(Proc) ? @url.call(resource) : @url
        end

        def classes
          [
            STYLE_CLASSES[@style],
            @additional_classes
          ].compact.join(' ')
        end
      end
    end
  end
end
