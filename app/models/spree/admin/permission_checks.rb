module Spree
  module Admin
    module PermissionChecks
      def with_availability_check(availability_check)
        @availability_checks << availability_check
        self
      end

      def with_manage_ability_check(*classes)
        @availability_checks << ->(ability, _current) { classes.any? { |c| ability.can?(:manage, c) } }
        self
      end

      def with_admin_ability_check(*classes)
        @availability_checks << ->(ability, _current) { classes.any? { |c| ability.can?(:admin, c) } }
        self
      end

      def with_index_ability_check(*classes)
        @availability_checks << ->(ability, _current) { classes.any? { |c| ability.can?(:index, c) } }
        self
      end

      def with_create_ability_check(*classes)
        @availability_checks << ->(ability, _current) { classes.any? { |c| ability.can?(:create, c) } }
        self
      end

      def with_update_ability_check
        @availability_checks << ->(ability, resource) { ability.can?(:update, resource) }
        self
      end

      def with_resend_ability_check
        @availability_checks << ->(ability, resource) { ability.can?(:resend, resource) }
        self
      end

      def with_fire_ability_check
        @availability_checks << ->(ability, resource) { ability.can?(:fire, resource) }
        self
      end

      def with_state_change_check(event)
        @availability_checks << ->(_ability, resource) { resource.send("can_#{event}?") }
        self
      end
    end
  end
end
