module Spree
  module Admin
    module Resources
      module AvailabilityBuilderMethods
        def with_availability_check(availability_check)
          @availability_check = availability_check
          self
        end

        def with_update_availability_check
          @availability_check = ->(ability, resource) { ability.can?(:update, resource) }
          self
        end
      end
    end
  end
end
