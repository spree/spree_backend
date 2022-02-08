module Spree
  module Admin
    module MetadataConcern
      extend ActiveSupport::Concern

      included do
        def assert_metadata(object)
          return unless params[:public_metadata].present?

          params[:public_metadata][:key].each_with_index do |key, i|
            next unless key.present?

            object.public_metadata[format_key(key)] = params[:public_metadata][:value][i]
          end
        end

        private

        def format_key(key)
          key.downcase.parameterize.underscore.to_sym
        end
      end
    end
  end
end
