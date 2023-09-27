module Spree
  module Admin
    module Resources
      module ConditionalChecker
        def with_active_check
          @active_check = ->(current_tab, text) { current_tab == text }
          self
        end

        def with_completed_check
          @completed_check = ->(resource) { resource.completed? }
          self
        end
      end
    end
  end
end
