module Spree
  module Admin
    module Actions
      class OrderDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_approve_action(root)
          add_cancel_action(root)
          add_resume_action(root)
          add_resend_action(root)
          add_reset_download_links_action(root)
          root
        end

        private

        def add_approve_action(root)
          action =
            ActionBuilder.new('approve', ->(resource) { approve_admin_order_path(resource) }).
            with_icon_key('approve.svg').
            with_label_translation_key('admin.order.events.approve').
            with_method(:put).
            with_data_attributes({ confirm: Spree.t(:order_sure_want_to, event: :approve) }).
            with_state_change_check('approve').
            with_fire_ability_check.
            build

          root.add(action)
        end

        def add_cancel_action(root)
          action =
            ActionBuilder.new('cancel', ->(resource) { cancel_admin_order_path(resource) }).
            with_icon_key('cancel.svg').
            with_label_translation_key('admin.order.events.cancel').
            with_method(:put).
            with_data_attributes({ confirm: Spree.t(:order_sure_want_to, event: :cancel) }).
            with_state_change_check('cancel').
            with_fire_ability_check.
            build

          root.add(action)
        end

        def add_resume_action(root)
          action =
            ActionBuilder.new('resume', ->(resource) { resume_admin_order_path(resource) }).
            with_icon_key('resume.svg').
            with_label_translation_key('admin.order.events.resume').
            with_method(:put).
            with_data_attributes({ confirm: Spree.t(:order_sure_want_to, event: :resume) }).
            with_state_change_check('resume').
            with_fire_ability_check.
            build

          root.add(action)
        end

        def add_resend_action(root)
          action =
            ActionBuilder.new('resend', ->(resource) { resend_admin_order_path(resource) }).
            with_icon_key('envelope.svg').
            with_label_translation_key('admin.order.events.resend').
            with_method(:post).
            with_style(::Spree::Admin::Actions::ActionStyle::SECONDARY).
            with_resend_ability_check.
            build

          root.add(action)
        end

        def add_reset_download_links_action(root)
          action =
            ActionBuilder.new('reset_download_links', ->(resource) { reset_digitals_admin_order_path(resource) }).
            with_icon_key('hdd.svg').
            with_label_translation_key('admin.digitals.reset_download_links').
            with_method(:put).
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:update, resource) && resource.some_digital?
              end
            ).
            build

          root.add(action)
        end
      end
    end
  end
end
