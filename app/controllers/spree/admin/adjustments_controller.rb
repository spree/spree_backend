module Spree
  module Admin
    class AdjustmentsController < ResourceController
      belongs_to 'spree/order', find_by: :number

      create.after :update_totals
      destroy.after :update_totals
      update.after :update_totals

      skip_before_action :load_resource, only: [:toggle_state, :edit, :update, :destroy]

      before_action :find_adjustment, only: [:destroy, :edit, :update]

      after_action :delete_promotion_from_order, only: [:destroy], if: -> { @adjustment.destroyed? && @adjustment.promotion? }

      def index
        @adjustments = @order.all_adjustments.eligible.order(created_at: :asc)
      end

      private

      def find_adjustment
        # Need to assign to @object here to keep ResourceController happy
        @adjustment = @object = parent.all_adjustments.find(params[:id])
      end

      def update_totals
        @order.reload.update_with_updater!
      end

      # Override method used to create a new instance to correctly
      # associate adjustment with order
      def build_resource
        parent.adjustments.build(order: parent)
      end

      def delete_promotion_from_order
        return if @adjustment.source.nil?

        @order.promotions.delete(@adjustment.source.promotion)
      end
    end
  end
end
