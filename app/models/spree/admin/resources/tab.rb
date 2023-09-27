module Spree
  module Admin
    module Resources
      class Tab
        include ActiveChecker
        include AvailabilityBuilderMethods

      attr_reader :icon_name, :text, :classes

        def initialize(icon_name, text, url, classes, options = {})
          @icon_name = icon_name
          @text = text
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
          @active_check.call(current_tab, text)
        end
      end
    end
  end
end
