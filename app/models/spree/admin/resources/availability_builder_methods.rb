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

        def with_index_availability_check(klass)
          @availability_check = ->(ability, _resource) { ability.can?(:index, klass) }
          self
        end
      end
    end
  end
end
