module Spree
  module Admin
    module Resources
      class Tab
        include ActiveChecker
        include AvailabilityBuilderMethods

        attr_reader :icon_name, :text, :partial_name, :classes

        def initialize(icon_name, text, url, partial_name, classes, options = {})
          @icon_name = icon_name
          @text = text
          @url = url
          @partial_name = partial_name
          @classes = classes
        end

        def available?(current_ability, current_store)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, current_store)
        end

        def url(resource = nil)
          @url.is_a?(Proc) ? @url.call(resource) : @url
        end

        def active?(current_tab, partial_name)
          @active_check.call(current_tab, partial_name)
        end
      end
    end
  end
end
