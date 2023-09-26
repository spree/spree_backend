module Spree
  module Admin
    module Resources
      module ActiveChecker
        def with_active_check
          @active_check = ->(current_tab, partial_name) { current_tab == partial_name }
          self
        end
      end
    end
  end
end
