module Spree
  module Admin
    class DigitalsController < ResourceController
      belongs_to 'spree/product', find_by: :slug

      private

      def collection_url
        spree.admin_product_digitals_path(@product)
      end

      def permitted_resource_params
        params.require(:digital).permit(permitted_digital_attributes)
      end

      def permitted_digital_attributes
        %i[variant_id attachment attachment_file_name attachment_content_type]
      end
    end
  end
end
