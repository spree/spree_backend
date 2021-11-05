module Spree
  module Admin
    class StockItemsController < Spree::Admin::BaseController
      before_action :determine_backorderable, only: :update

      def update
        stock_item.save
        respond_to do |format|
          format.js { head :ok }
        end
      end

      def create
        variant = current_store.variants.find(params[:variant_id])
        stock_location = StockLocation.find(params[:stock_location_id])
        stock_movement = stock_location.stock_movements.build(stock_movement_params)
        stock_movement.stock_item = stock_location.set_up_stock_item(variant)

        if stock_movement.save
          flash[:success] = flash_message_for(stock_movement, :successfully_created)
        else
          flash[:error] = Spree.t(:could_not_create_stock_movement)
        end

        redirect_back fallback_location: spree.stock_admin_product_url(variant.product)
      end

      def destroy
        stock_item.destroy

        respond_with(@stock_item) do |format|
          format.html { redirect_back fallback_location: spree.stock_admin_product_url(stock_item.product) }
          format.js
        end
      end

      private

      def stock_movement_params
        params.require(:stock_movement).permit(permitted_stock_movement_attributes)
      end

      def stock_item
        @stock_item ||= current_store.stock_items.find(params[:id])
      end

      def determine_backorderable
        stock_item.backorderable = params[:stock_item].present? && params[:stock_item][:backorderable].present?
      end
    end
  end
end
