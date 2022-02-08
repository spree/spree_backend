module Spree
  module Admin
    module PrivateMetadataConcern
      extend ActiveSupport::Concern

      included do
        def create_private_metadata
          render 'spree/admin/private_metadata/add'
        end

        def delete_private_metadata
          @object.private_metadata.delete(params[:key].to_sym)

          if @object.save!
            respond_to do |format|
              format.turbo_stream do
                render turbo_stream: turbo_stream.remove("private_metadata_row_#{params[:key]}")
              end
            end
          end
        end
      end
    end
  end
end
