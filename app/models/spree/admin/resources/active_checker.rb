module Spree
  module Admin
    module Resources
      module ActiveChecker
        def with_active_check
          @active_check = ->(current_tab, text) { current_tab == text }
          self
        end
      end
    end
  end
end
