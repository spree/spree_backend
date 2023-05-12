module Spree
  module Admin
    class DataFeedsController < ResourceController
      def collection
        return @collection if @collection.present?

        @collection = super
        @collection.page(params[:page]).per(params[:per_page])
      end
    end
  end
end
