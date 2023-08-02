module Spree
  module Admin
    module MainMenu
      class Item
        attr_reader :key, :label_translation_key, :icon_key, :url, :match_path

        def initialize(key, label_translation_key, url, icon_key, availability_check, match_path) # rubocop:disable Metrics/ParameterLists
          @key = key
          @label_translation_key = label_translation_key
          @url = url
          @icon_key = icon_key
          @availability_check = availability_check
          @match_path = match_path
        end

        def available?(current_ability, current_store)
          return true unless @availability_check.present?

          @availability_check.call(current_ability, current_store)
        end

        def children?
          false
        end
      end
    end
  end
end
