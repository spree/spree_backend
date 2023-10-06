module Spree
  module Admin
    module Actions
      class ActionBuilder
        include AvailabilityBuilderMethods

        def initialize(config)
          @icon_name = config[:icon_name]
          @name = config[:name]
          @url = config[:url]
          @classes = config[:classes]
          @availability_check = nil
          @method = config[:method]
          @id = config[:id]
        end

        def build
          Action.new(build_config)
        end

        private

        def build_config
          {
            icon_name: @icon_name,
            name: @name,
            url: @url,
            classes: @classes,
            availability_check: @availability_check,
            text: text,
            method: @method,
            id: @id
          }
        end

        def text
          ::Spree.t(@name)
        end

        # def available?(current_ability, resource)
        #   return true unless @availability_check.present?

        #   @availability_check.call(current_ability, resource)
        # end

        # def url(resource = nil)
        #   @url.is_a?(Proc) ? @url.call(resource) : @url
        # end

        # def active?(current_tab)
        #   @active_check.call(current_tab, partial_name)
        # end

        # def complete?(resource)
        #   return true unless @completed_check.present?

        #   @completed_check.call(resource)
        # end

        # def text
        #   return true unless @translate.present?

        #   @translate.call(name)
        # end
      end
    end
  end
end
