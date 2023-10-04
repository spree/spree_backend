module Spree
  module Admin
    module Tabs
      class Tab
        include ConditionalChecker
        include AvailabilityBuilderMethods
        include DataHook

        attr_reader :icon_name, :name, :classes, :partial_name

        def initialize(config)
          @icon_name = config[:icon_name]
          @name = config[:name]
          @url = config[:url]
          @classes = config[:classes]
          @partial_name = config[:partial_name]
        end

        def available?(current_ability, resource)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, resource)
        end

        def url(resource = nil)
          @url.is_a?(Proc) ? @url.call(resource) : @url
        end

        def active?(current_tab)
          @active_check.call(current_tab, partial_name)
        end

        def complete?(resource)
          return true unless @completed_check.present?

          @completed_check.call(resource)
        end

        def text
          ::Spree.t(name)
        end

        def data_hook
          @data_hook.presence
        end
      end
    end
  end
end
