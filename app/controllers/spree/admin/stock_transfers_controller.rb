module Spree
  module Admin
    class StockTransfersController < Admin::BaseController
      before_action :load_stock_locations, only: :index

      def index
        @q = StockTransfer.ransack(params[:q])

        @stock_transfers = @q.result.
                           includes(stock_movements: { stock_item: :stock_location }).
                           order(created_at: :desc).
                           page(params[:page])
      end

      def show
        @stock_transfer = StockTransfer.find_by!(number: params[:id])
      end

      def new; end

      def create
        if params[:variant].nil?
          flash.now[:error] = Spree.t('stock_transfer.errors.must_have_variant')
          render :new, status: :unprocessable_entity
        elsif any_missing_variants?(params[:variant])
          flash.now[:error] = Spree.t('stock_transfer.errors.variants_unavailable', stock: source_location.name)
          render :new, status: :unprocessable_entity
        else
          variants = Hash.new(0)
          params[:variant].each_with_index do |variant_id, i|
            variants[variant_id] += params[:quantity][i].to_i
          end
          stock_transfer = StockTransfer.create(reference: params[:reference])
          stock_transfer.transfer(source_location,
                                  destination_location,
                                  variants)

          flash[:success] = Spree.t(:stock_successfully_transferred)
          redirect_to spree.admin_stock_transfer_path(stock_transfer)
        end
      end

      private

      def load_stock_locations
        @stock_locations = stock_locations_scope.active.order_default
      end

      def source_location
        @source_location ||= params.key?(:transfer_receive_stock) ? nil : stock_locations_scope.find(params[:transfer_source_location_id])
      end

      def destination_location
        @destination_location ||= stock_locations_scope.find(params[:transfer_destination_location_id])
      end

      def any_missing_variants?(variant_ids)
        source_location&.stock_items&.where(variant_id: variant_ids, count_on_hand: 0)&.any?
      end

      def stock_locations_scope
        Spree::StockLocation.accessible_by(current_ability, :update)
      end
    end
  end
end
