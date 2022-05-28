module Spree
  module Admin
    module MetadataConcern
      extend ActiveSupport::Concern

      included do
        def create_metadata
          render 'spree/admin/metadata/add', locals: { kind: params[:kind] }
        end

        def delete_metadata
          @object.send("#{params[:kind]}_metadata").delete(params[:key].to_sym)

          if @object.save!
            respond_to do |format|
              format.turbo_stream do
                render turbo_stream: turbo_stream.remove("#{params[:kind]}_metadata_row_#{params[:key]}")
              end
            end
          end
        end

        private

        def process_metadata(object)
          assert_metadata(object, 'public') if params[:public_metadata].present?
          assert_metadata(object, 'private') if params[:private_metadata].present?
        end

        def assert_metadata(object, kind)
          params["#{kind}_metadata".to_sym][:key].each_with_index do |key, i|
            next if key.blank?

            if params["#{kind}_metadata".to_sym][:previous_key].present? &&
                params["#{kind}_metadata".to_sym][:previous_key][i].present? &&
                key.to_s != params["#{kind}_metadata".to_sym][:previous_key][i].to_s

              object.send("#{kind}_metadata").delete(params["#{kind}_metadata".to_sym][:previous_key][i].to_sym)
            end

            object.send("#{kind}_metadata")[format_key(key)] = params["#{kind}_metadata".to_sym][:value][i]
          end
        end

        def format_key(key)
          key.downcase.parameterize.underscore.to_sym
        end
      end
    end
  end
end
