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
      end
    end
  end
end
