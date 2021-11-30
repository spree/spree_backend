module Spree
  module Admin
    module WebhooksSubscribersHelper
      def event_list_for(resource_name)
        supported_events[resource_name].join(',')
      end

      def event_checkbox_for(resource_name, form)
        content_tag :div, class: 'col-xs-12 col-sm-6 col-md-4 col-lg-4' do
          (form.check_box :subscriptions, event_checkbox_opts(resource_name), event_list_for(resource_name), nil) + ' ' +
            Spree.t(resource_name.to_s.pluralize)
        end
      end

      def subscribe_to_all_events?
        @webhooks_subscriber.new_record? || @webhooks_subscriber.subscriptions == ['*']
      end

      private

      def supported_events
        @supported_events ||= Spree::Webhooks::Subscriber.supported_events
      end

      def event_checkbox_opts(resource_name)
        {
          multiple: true,
          class: 'events-checkbox',
          checked: subscribed_to_resource?(resource_name)
        }
      end

      def subscribed_to_resource?(resource_name)
        @webhooks_subscriber.subscriptions&.any? { |event| event.include? "#{resource_name}." }
      end
    end
  end
end
