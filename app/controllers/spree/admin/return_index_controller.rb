module Spree
  module Admin
    class ReturnIndexController < BaseController
      def return_authorizations
        collection(Spree::ReturnAuthorization.for_store(current_store))
        respond_with(@collection)
      end

      def customer_returns
        collection(current_store.customer_returns)
        respond_with(@collection)
      end

      private

      def collection(resource)
        return @collection if @collection.present?

        params[:q] ||= {}

        # @search needs to be defined as this is passed to search_form_for
        @search = resource.ransack(params[:q])
        per_page = params[:per_page] || Spree::Backend::Config[:admin_customer_returns_per_page]
        @collection = @search.result.order(created_at: :desc).page(params[:page]).per(per_page)
      end
    end
  end
end
