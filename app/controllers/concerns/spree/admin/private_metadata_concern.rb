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

        private

        def assert_private_metadata(object)
          return unless params[:private_metadata].present?

          params[:private_metadata][:key].each_with_index do |key, i|
            next unless key.present?

            if key.to_s != params[:private_metadata][:previous_key][i].to_s
              object.private_metadata.delete(params[:private_metadata][:previous_key][i].to_sym)
            end

            object.private_metadata[format_key(key)] = params[:private_metadata][:value][i]
          end
        end

        def format_key(key)
          key.downcase.parameterize.underscore.to_sym
        end
      end
    end
  end
end
