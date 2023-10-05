module Spree
  module Admin
    module Actions
      module AvailabilityBuilderMethods
        def with_create_availability_check(klass)
          @availability_check = ->(ability, _resource) { ability.can?(:create, klass) }
          self
        end

        def with_resend_availability_check
          @availability_check = ->(ability, resource) { ability.can?(:resend, resource) }
          self
        end

        # def with_availability_check(availability_check)
        #   @availability_check = availability_check
        #   self
        # end

        # def with_update_availability_check
        #   @availability_check = ->(ability, resource) { ability.can?(:update, resource) }
        #   self
        # end

        # def with_index_availability_check(klass)
        #   @availability_check = ->(ability, _resource) { ability.can?(:index, klass) }
        #   self
        # end

        # def with_admin_availability_check(klass)
        #   @availability_check = ->(ability, _resource) { ability.can?(:admin, klass) }
        #   self
        # end
      end
    end
  end
end
