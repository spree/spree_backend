module Spree
  module Admin
    module MetadataConcern
      extend ActiveSupport::Concern

      included do
        def assert_metadata(object)

          byebug
          params[:public_metadata][:key].each_with_index do |key, i|
            if key.present?
              if params[:public_metadata][:type][i] == 'string'
                object.public_metadata[key.to_sym] = params[:public_metadata][:value][i]
              elsif params[:public_metadata][:type][i] == 'integer'
                object.public_metadata[key.to_sym] = params[:public_metadata][:value][i].to_f
              end
            end

            if params[:public_metadata][:delete].present? && (params[:public_metadata][:delete][i] == '1')
              object.public_metadata.delete(key.to_sym)
            end
          end
        end
      end
    end
  end
end
