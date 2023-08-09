module Spree
  module Admin
    module MainMenu
      module AvailabilityBuilderMethods
        def with_availability_check(availability_check)
          @availability_check = availability_check
          self
        end

        def with_manage_ability_check(*any_of_resources)
          @availability_check = ->(ability, _store) { any_of_resources.any? { |r| ability.can?(:manage, r) } }
          self
        end

        def with_admin_ability_check(*any_of_resources)
          @availability_check = ->(ability, _store) { any_of_resources.any? { |r| ability.can?(:admin, r) } }
          self
        end
      end
    end
  end
end
