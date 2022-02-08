module Spree
  module Admin
    module PublicMetadataConcern
      extend ActiveSupport::Concern

      included do
        def create_public_metadata
          render 'spree/admin/public_metadata/add'
        end

        def delete_public_metadata
          @object.public_metadata.delete(params[:key].to_sym)

          if @object.save!
            respond_to do |format|
              format.turbo_stream do
                render turbo_stream: turbo_stream.remove("public_metadata_row_#{params[:key]}")
              end
            end
          end
        end

        private

        def assert_public_metadata(object)
          return unless params[:public_metadata].blank?

          params[:public_metadata][:key].each_with_index do |key, i|
            next unless key.present?

            object.public_metadata[format_key(key)] = params[:public_metadata][:value][i]
          end
        end

        def format_key(key)
          key.downcase.parameterize.underscore.to_sym
        end
      end
    end
  end
end
