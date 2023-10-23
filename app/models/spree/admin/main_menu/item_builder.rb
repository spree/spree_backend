module Spree
  module Admin
    module MainMenu
      class ItemBuilder
        include ::Spree::Admin::PermissionChecks

        def initialize(key, url)
          @key = key
          @label_translation_key = key
          @url = url
          @icon_key = nil
          @availability_check = nil
          @match_path = nil
        end

        def with_label_translation_key(key)
          @label_translation_key = key
          self
        end

        def with_icon_key(icon_key)
          @icon_key = icon_key
          self
        end

        def with_match_path(match_path)
          @match_path = match_path
          self
        end

        def build
          Item.new(@key, @label_translation_key, @url, @icon_key, @availability_check, @match_path)
        end
      end
    end
  end
end
