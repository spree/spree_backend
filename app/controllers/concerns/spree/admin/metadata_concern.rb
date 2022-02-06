module Spree
  module Admin
    module MetadataConcern
      extend ActiveSupport::Concern

      included do
        def assert_metadata(object)
          return unless params[:public_metadata].present?

          params[:public_metadata][:key].each_with_index do |key, i|
            next unless key.present?

            object.public_metadata[key.to_sym] = params[:public_metadata][:value][i]
          end
        end
      end
    end
  end
end
