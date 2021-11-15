module Spree
  module Admin
    module WebhooksSubscribersHelper
      ADDITIONAL_EVENTS_LISTS = {
        order: 'order.canceled,order.paid,order.placed,order.resumed,order.shipped',
        payment: 'payment.paid,payment.voided',
        product: 'product.back_in_stock,product.backorderable,product.discontinued,product.out_of_stock',
        variant: 'variant.back_in_stock,variant.backorderable,variant.discontinued,variant.out_of_stock',
      }

      def event_list_for(resource_name)
        result = default_event_list(resource_name)
        result += ",#{ADDITIONAL_EVENTS_LISTS[resource_name]}" if ADDITIONAL_EVENTS_LISTS.include?(resource_name)
        result
      end

      def event_checkbox_for(resource_name, f)
        content_tag :div, class: 'col-xs-12 col-sm-6 col-md-4 col-lg-4' do
          (f.check_box :subscriptions, event_checkbox_opts(resource_name), event_list_for(resource_name), nil) + ' ' + Spree.t(resource_name.to_s.pluralize) + tag(:br) + '(' + event_list_for(resource_name).gsub(',', ', ') + ')'
        end
      end

      private

      def event_checkbox_opts(resource_name)
        {
          multiple: true,
          class: 'events-checkbox',
          checked: subscribed_to_resource?(resource_name)
        }
      end

      def default_event_list(resource_name)
        "#{resource_name}.create,#{resource_name}.update,#{resource_name}.delete"
      end

      def subscribed_to_resource?(resource_name)
        @webhooks_subscriber.subscriptions&.any? { |event| event.include? "#{resource_name.to_s}." }
      end
    end
  end
end
