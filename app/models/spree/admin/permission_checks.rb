module Spree
  module Admin
    module PermissionChecks
      def with_availability_check(availability_check)
        @availability_check = availability_check
        self
      end

      def with_manage_ability_check(*classes)
        @availability_check = ->(ability, _current) { classes.any? { |c| ability.can?(:manage, c) } }
        self
      end

      def with_admin_ability_check(*classes)
        @availability_check = ->(ability, _current) { classes.any? { |c| ability.can?(:admin, c) } }
        self
      end

      def with_index_ability_check(*classes)
        @availability_check = ->(ability, _current) { classes.any? { |c| ability.can?(:index, c) } }
        self
      end

      def with_update_ability_check
        @availability_check = ->(ability, resource) { ability.can?(:update, resource) }
        self
      end
    end
  end
end
