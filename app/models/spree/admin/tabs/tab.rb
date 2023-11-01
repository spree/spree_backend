module Spree
  module Admin
    module Tabs
      class Tab
        attr_reader :icon_key, :key, :label_translation_key, :data_hook

        def initialize(key, label_translation_key, url, icon_key, partial_name, availability_checks, active_check, data_hook) # rubocop:disable Metrics/ParameterLists
          @key = key
          @label_translation_key = label_translation_key
          @url = url
          @icon_key = icon_key
          @partial_name = partial_name
          @availability_checks = availability_checks
          @active_check = active_check
          @data_hook = data_hook
        end

        def available?(current_ability, resource)
          return true if @availability_checks.empty?

          result = @availability_checks.map { |check| check.call(current_ability, resource) }

          result.all?(true)
        end

        def url(resource = nil)
          @url.is_a?(Proc) ? @url.call(resource) : @url
        end

        def active?(current_tab)
          return false unless @active_check.present?

          @active_check.call(current_tab, @partial_name)
        end
      end
    end
  end
end
