module Spree
  module Admin
    class PromotionBatchesController < ResourceController
      before_action :set_template_promotion

      def index
        @promotion_batches = Spree::PromotionBatch.where(template_promotion: @template_promotion)
      end

      def new
        @promotion_batch = @template_promotion.promotion_batches.build
      end

      def create
        Spree::PromotionBatches::CreateWithRandomCodes.new.call(template_promotion: @template_promotion, amount: params[:amount].to_i, random_characters: params[:random_characters].to_i, prefix: params[:prefix], suffix: params[:suffix])
        redirect_to(admin_template_promotion_promotion_batches_path(template_promotion_id: @template_promotion.id))
      end

      def import; end

      def process_import
        file = params[:file].read
        Spree::PromotionBatches::CreateWithCodes.new.call(template_promotion: @template_promotion, codes: file.split("\n"))
        redirect_to(admin_template_promotion_promotion_batches_path(template_promotion_id: @template_promotion.id))
      end

      def export
        @promotion_batch = @template_promotion.promotion_batches.find(params[:promotion_batch_id])
        csv = Spree::PromotionBatches::Export.new.call(promotion_batch: @promotion_batch)
        send_data csv, filename: "codes_#{@promotion_batch}.csv"
      end

      private

      def collection_url
        admin_template_promotion_promotion_batches_url(@template_promotion)
      end

      def new_object_url(options = nil)
        new_admin_template_promotion_promotion_batch_url(@template_promotion)
      end

      def set_template_promotion
        @template_promotion = Spree::Promotion.templates.find(params[:template_promotion_id])
      end
    end
  end
end
