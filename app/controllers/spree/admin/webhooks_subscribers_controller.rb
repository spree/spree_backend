module Spree
  module Admin
    class WebhooksSubscribersController < ResourceController
      create.before :process_subscriptions
      update.before :process_subscriptions

      def index
        params[:q] ||= {}
        params[:q][:s] ||= 'created_at desc'

        @webhooks_subscribers = Webhooks::Subscriber.all

        search = @webhooks_subscribers.ransack(params[:q])
        @webhooks_subscribers = search.result.
                                includes(:events).
                                page(params[:page]).
                                per(params[:per_page])
      end

      def show
        @webhooks_subscriber = Webhooks::Subscriber.find(params[:id])
      end

      private

      def resource
        @resource ||= Spree::Admin::Resource.new 'spree/admin/webhooks/subscribers', 'subscribers', nil
      end

      def process_subscriptions
        if params[:subscribe_to_all_events] == 'true'
          params[:webhooks_subscriber][:subscriptions] = ['*']
        else
          params[:webhooks_subscriber][:subscriptions] ||= []
          params[:webhooks_subscriber][:subscriptions] = params[:webhooks_subscriber][:subscriptions].flat_map { |events| events.split(',') }
        end
      end
    end
  end
end
