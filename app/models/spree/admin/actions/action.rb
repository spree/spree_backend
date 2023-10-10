module Spree
  module Admin
    module Actions
      class Action
        attr_reader :icon_name, :name, :classes, :text, :method, :id, :target, :data

        def initialize(config)
          @icon_name =          config[:icon_name]
          @name =               config[:name]
          @url =                config[:url]
          @classes =            config[:classes]
          @availability_checks = config[:availability_checks]
          @text =               config[:text]
          @method =             config[:method]
          @id =                 config[:id]
          @target =             config[:target]
          @data =               config[:data]
        end

        def available?(current_ability, resource = nil)
          return true if @availability_checks.empty?

          result = @availability_checks.map { |check| check.call(current_ability, resource) }

          result.all?(true)
        end

        def url(resource = nil)
          @url.is_a?(Proc) ? @url.call(resource) : @url
        end

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
