module Spree
  module Admin
    class PublicMetadataController < BaseController
      include Spree::Admin::MetadataConcern

      before_action :find_resource, except: [:add]

      def create
        @object.public_metadata.update({ params[:public_metadata][:key].to_s => params[:public_metadata][:value] })
        @object.save!
      end

      def add; end

      def update
        assert_metadata(@object)
        @object.save!

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('metadata_form', partial: 'spree/admin/public_metadata/table', locals: { resource: @object })
          end
        end
      end

      def delete
        @object.public_metadata.delete(params[:key].to_sym)

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.remove('metadata_form')
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
