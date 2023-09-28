module Spree
  module Admin
    module Resources
      class Tab
        include ConditionalChecker
        include AvailabilityBuilderMethods
        include Translator

        attr_reader :icon_name, :name, :classes

        def initialize(icon_name, name, url, classes)
          @icon_name = icon_name
          @name = name
          @url = url
          @classes = classes
        end

        def available?(current_ability, resource)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, resource)
        end

        def url(resource = nil)
          @url.is_a?(Proc) ? @url.call(resource) : @url
        end

        def active?(current_tab)
          @active_check.call(current_tab, name)
        end

        def complete?(resource)
          return true unless @completed_check.present?

          @completed_check.call(resource)
        end

        def text
          return true unless @translate.present?

          @translate.call(name)
        end
      end
    end
  end
end
