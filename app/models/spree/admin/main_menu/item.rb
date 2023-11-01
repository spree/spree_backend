module Spree
  module Admin
    module MainMenu
      class Item
        attr_reader :key, :label_translation_key, :icon_key, :url, :match_path

        def initialize(key, label_translation_key, url, icon_key, availability_checks, match_path) # rubocop:disable Metrics/ParameterLists
          @key = key
          @label_translation_key = label_translation_key
          @url = url
          @icon_key = icon_key
          @availability_checks = availability_checks
          @match_path = match_path
        end

        def available?(current_ability, resource)
          return true if @availability_checks.empty?

          result = @availability_checks.map { |check| check.call(current_ability, resource) }

          result.all?(true)
        end

        def children?
          false
        end
      end
    end
  end
end
