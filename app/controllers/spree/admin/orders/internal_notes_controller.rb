module Spree
  module Admin
    module Orders
      class InternalNotesController < Spree::Admin::BaseController
        include Spree::Admin::OrderConcern

        before_action :load_order

        def show; end

        def edit; end

        def update
          if @order.update(internal_note: params[:internal_note])
            redirect_to admin_order_internal_note_path(@order)
          else
            render :edit, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
