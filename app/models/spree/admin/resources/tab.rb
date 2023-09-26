module Spree
  module Admin
    module Resources
      class Tab
        attr_reader :icon_name, :text, :url, :partial_name, :classes, :availability_check

        def initialize(icon_name, text, url, partial_name, classes, availability_check, options = {})
          @icon_name = icon_name
          @text = text
          @url = url
          @partial_name = partial_name
          @classes = classes
          @availability_check = availability_check
        end

        def available?(current_ability, current_store)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, current_store)
        end
      end
    end
  end
end
