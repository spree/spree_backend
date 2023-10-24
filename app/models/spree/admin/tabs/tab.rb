module Spree
  module Admin
    module Tabs
      class Tab
        attr_reader :icon_name, :key, :classes, :text, :data_hook

        def initialize(config)
          @icon_name =          config[:icon_name]
          @key =                config[:key]
          @url =                config[:url]
          @partial_name =       config[:partial_name]
          @availability_checks = config[:availability_checks]
          @active_check =       config[:active_check]
          @completed_check =    config[:completed_check]
          @text =               config[:text]
          @data_hook =          config[:data_hook]
          @classes =            css_classes
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
          @active_check.call(current_tab, @partial_name)
        end

        def complete?(resource)
          return true unless @completed_check.present?

          @completed_check.call(resource)
        end

        private

        def css_classes
          'nav-link'
        end
      end
    end
  end
end
