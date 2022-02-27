module Spree
  module Admin
    module Orders
      class InternalNotesController < Spree::Admin::BaseController
        include Spree::Admin::OrderConcern

        before_action :load_order

        def show; end

        def edit; end

        def update
          if @order.update(order_params)
            redirect_to admin_order_internal_note_path(@order)
          else
            render :edit, status: :unprocessable_entity
          end
        end

        private

        def order_params
          params.require(:order).permit(:internal_note)
        end
      end
    end
  end
end
