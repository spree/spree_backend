module Spree
  module Admin
    class PromotionBatchesController < ResourceController
      def update
        if @object.template_promotion_id
          flash[:error] = Spree.t(:template_promotion_already_assigned)
          respond_with(@object) do |format|
            format.html { render action: :edit, status: :unprocessable_entity }
            format.js { render layout: false, status: :unprocessable_entity }
          end
          return
        end
        super
      end

      def destroy
        result = Spree::PromotionBatches::Destroy.call(promotion_batch: @promotion_batch)

        if result.success?
          flash[:success] = flash_message_for(@promotion_batch, :successfully_removed)
        else
          flash[:error] = @promotion_batch.errors.full_messages.join(', ')
        end

        respond_with(@promotion_batch) do |format|
          format.html { redirect_to location_after_destroy }
          format.js   { render_js_for_destroy }
        end
      end

      def csv_export
        send_data Spree::PromotionBatches::PromotionCodesExporter.new(params).call,
                  filename: "promo_codes_from_batch_id_#{params[:id]}.csv",
                  disposition: :attachment,
                  type: 'text/csv'
      end

      def csv_import
        file = params[:file]
        Spree::PromotionBatches::PromotionCodesImporter.new(file: file, promotion_batch_id: params[:id]).call
        redirect_back fallback_location: admin_promotions_path, notice: Spree.t('code_upload')
      rescue Spree::PromotionBatches::PromotionCodesImporter::Error => e
        redirect_back fallback_location: admin_promotions_path, alert: e.message
      end

      def populate
        batch_id = params[:id]
        options = {
          batch_size: params[:batch_size].to_i,
          affix: params.dig(:code, :affix)&.to_sym,
          content: params[:affix_content],
          deny_list: params[:forbidden_phrases].split,
          random_part_bytes: params[:random_part_bytes].to_i
        }

        Spree::Promotions::PopulatePromotionBatch.new(batch_id, options).call

        flash[:success] = Spree.t('promotion_batch_populated')
        redirect_to spree.edit_admin_promotion_batch_url(@promotion_batch)
      end
    end
  end
end
