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
            ActionBuilder.new(approve_config).
            with_state_change_check('approve').
            with_fire_ability_check.
            build

          root.add(action)
        end

        def approve_config
          {
            icon_name: 'approve.svg',
            key: :approve,
            url: ->(resource) { approve_admin_order_path(resource) },
            classes: 'btn-light',
            method: :put,
            translation_options: {
              scope: 'admin.order.events'
            },
            data: { confirm: Spree.t(:order_sure_want_to, event: :approve) }
          }
        end

        def add_cancel_action(root)
          action =
            ActionBuilder.new(cancel_config).
            with_state_change_check('cancel').
            with_fire_ability_check.
            build

          root.add(action)
        end

        def cancel_config
          {
            icon_name: 'cancel.svg',
            key: :cancel,
            url: ->(resource) { cancel_admin_order_path(resource) },
            classes: 'btn-light',
            method: :put,
            translation_options: {
              scope: 'admin.order.events'
            },
            data: { confirm: Spree.t(:order_sure_want_to, event: :cancel) }
          }
        end

        def add_resume_action(root)
          action =
            ActionBuilder.new(resume_config).
            with_state_change_check('resume').
            with_fire_ability_check.
            build

          root.add(action)
        end

        def resume_config
          {
            icon_name: 'resume.svg',
            key: :resume,
            url: ->(resource) { resume_admin_order_path(resource) },
            classes: 'btn-light',
            method: :put,
            translation_options: {
              scope: 'admin.order.events'
            },
            data: { confirm: Spree.t(:order_sure_want_to, event: :resume) }
          }
        end

        def add_resend_action(root)
          action =
            ActionBuilder.new(resend_config).
            with_resend_ability_check.
            build

          root.add(action)
        end

        def resend_config
          {
            icon_name: 'envelope.svg',
            key: :resend,
            url: ->(resource) { resend_admin_order_path(resource) },
            classes: 'btn-secondary',
            method: :post,
            translation_options: {
              scope: 'admin.order.events',
              default: ::Spree.t(:resend)
            }
          }
        end

        def add_reset_download_links_action(root)
          action =
            ActionBuilder.new(reset_download_links_config).
            with_availability_check(
              lambda do |ability, resource|
                ability.can?(:update, resource) && resource.some_digital?
              end
            ).
            build

          root.add(action)
        end

        def reset_download_links_config
          {
            icon_name: 'hdd.svg',
            key: 'admin.digitals.reset_download_links',
            url: ->(resource) { reset_digitals_admin_order_path(resource) },
            method: :put
          }
        end
      end
    end
  end
end
