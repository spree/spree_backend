module Spree
  module Admin
    module Tabs
      class TabBuilder
        include ConditionalChecker
        include ::Spree::Admin::PermissionChecks
        include DataHook

        def initialize(config)
          @icon_name =           config[:icon_name]
          @key =                 config[:key]
          @url =                 config[:url]
          @partial_name =        config[:partial_name]
          @availability_checks = []
          @active_check =        nil
          @completed_check =     nil
        end

        def build
          Tab.new(build_config)
        end

        private

        def build_config
          {
            icon_name: @icon_name,
            key: @key,
            url: @url,
            partial_name: @partial_name,
            availability_checks: @availability_checks,
            active_check: @active_check,
            completed_check: @completed_check,
            text: text,
            data_hook: data_hook
          }
        end

        def text
          ::Spree.t(@key)
        end

        def data_hook
          @data_hook.presence
        end
      end
    end
  end
end
