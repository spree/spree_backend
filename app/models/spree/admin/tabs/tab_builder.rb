module Spree
  module Admin
    module Tabs
      class TabBuilder
        include ::Spree::Admin::PermissionChecks

        def initialize(key, url)
          @key = key
          @label_translation_key = key
          @url = url
          @icon_key = nil
          @partial_name = key
          @availability_checks = []
          @active_check = nil
          @data_hook = nil
        end

        def with_label_translation_key(key)
          @label_translation_key = key
          self
        end

        def with_icon_key(icon_key)
          @icon_key = icon_key
          self
        end

        def with_partial_name(partial_name)
          @partial_name = partial_name
          self
        end

        def with_active_check
          @active_check = ->(current_tab, partial_name) { current_tab.to_s == partial_name.to_s }
          self
        end

        def with_completed_check
          @availability_checks << ->(_current_ability, resource) { resource.completed? }
          self
        end

        def with_data_hook(data_hook)
          @data_hook = data_hook
          self
        end

        def build
          Tab.new(
            @key,
            @label_translation_key,
            @url,
            @icon_key,
            @partial_name,
            @availability_checks,
            @active_check,
            @data_hook
          )
        end
      end
    end
  end
end
