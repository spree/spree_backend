module Spree
  module Admin
    class PublicMetadataController < BaseController
      include Spree::Admin::MetadataConcern

      before_action :find_resource

      def create
        @object.public_metadata.update({ params[:public_metadata][:key].to_s => params[:public_metadata][:value] })
        @object.save!
      end

      def update
        assert_metadata(@object)
        @object.save!

        respond_with(@object) do |format|
          format.html { redirect_to '/admin' } # Swap this for turbo stream to render in place
          # It will be much easier than trying to redirect
          # to the correct location for each metadata type
          # Order, Address, Variant, Product.....
        end
      end

      def delete
        @object.public_metadata.delete(params[:key].to_sym)

        if @object.save!
          respond_with(@object) do |format|
            format.html { redirect_to '/admin' }
          end
        end
      end

      private

      def find_resource
        model_klazz = params[:klazz_name].constantize
        @object = model_klazz.find(params[:id])
      end

      def format_key
        # Use this method to format the key for use on api requests -> dot.notation seems standard
      end
    end
  end
end
