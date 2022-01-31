module Spree
  module Admin
    module MetadataConcern
      extend ActiveSupport::Concern

      included do
        def assert_metadata(object)
          return unless params[:public_metadata].present?

          params[:public_metadata][:key].each_with_index do |key, i|
            next unless key.present?

            assert_type = case params[:public_metadata][:type][i].downcase
                          when 'integer' then 'to_i'
                          when 'float' then 'to_f'
                          else 'to_s'
                          end

            object.public_metadata[key.to_sym] =
              params[:public_metadata][:key] =
                { type: params[:public_metadata][:type][i], value: params[:public_metadata][:value][i].send(assert_type),
                  description: params[:public_metadata][:description][i] }

            if params[:public_metadata][:delete].present? && params[:public_metadata][:delete][i] == '1'
              object.public_metadata.delete(key.to_sym)
            end
          end
        end
      end
    end
  end
end
