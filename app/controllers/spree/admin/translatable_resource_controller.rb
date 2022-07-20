module Spree
  module Admin
    class TranslatableResourceController < ResourceController

      def edit_translations
        params[:translation].each do |key, translation|
          translation.each do |locale, value|
            next unless value != ''
            I18n.with_locale(locale) do
              @object.public_send("#{key}=", value)
            end
          end
        end
        @object.save
        flash[:success] = Spree.t('notice_messages.translations_saved')
        # TODO there should be a better way to redirect
        @object.instance_of?(Spree::Product) ? redirect_to_product_edit_page : redirect_to_taxon_edit_page
      end

      def redirect_to_product_edit_page
        redirect_to spree.edit_admin_product_url(@object)
      end

      def redirect_to_taxon_edit_page
        redirect_to spree.edit_admin_taxonomy_taxon_path(@object.taxonomy, @object.id)
      end

    end
  end
end
