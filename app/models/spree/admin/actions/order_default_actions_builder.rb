module Spree
  module Admin
    module Actions
      class OrderDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          add_resend_action(root)
          add_reset_download_links_action(root)
          root
        end

        private

        def add_resend_action(root)
          action =
            ActionBuilder.new(resend_config).
            with_resend_availability_check.
            build

          root.add(action)
        end

        def resend_config
          {
            icon_name: 'envelope.svg',
            name: :resend,
            url: ->(resource) { resend_admin_order_path(resource) },
            classes: 'btn-secondary',
            method: :post,
            translation_options: {
              scope: 'admin.order.events'
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
            name: 'admin.digitals.reset_download_links',
            url: ->(resource) { reset_digitals_admin_order_path(resource) },
            method: :put
          }
        end
      end
    end
  end
end
