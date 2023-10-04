module Spree
  module Admin
    module Tabs
      class TabBuilder
        include ConditionalChecker
        include AvailabilityBuilderMethods
        include DataHook

        def initialize(config)
          @icon_name =          config[:icon_name]
          @name =               config[:name]
          @url =                config[:url]
          @classes =            config[:classes]
          @partial_name =       config[:partial_name]
          @availability_check = nil
          @active_check =       nil
          @completed_check =    nil
        end

        def build
          Tab.new(build_config)
        end

        private

        def build_config
          {
            icon_name: @icon_name,
            name: @name,
            url: @url,
            classes: @classes,
            partial_name: @partial_name,
            availability_check: @availability_check,
            active_check: @active_check,
            completed_check: @completed_check,
            text: text,
            data_hook: data_hook
          }
        end

        def text
          ::Spree.t(@name)
        end

        def data_hook
          @data_hook.presence
        end
      end
    end
  end
end
