module Spree
  module Admin
    class TranslatableResourceController < ResourceController

      def edit_translations
        params[:translation].each do |key, translation|
          translation.each do |locale, value|
            I18n.with_locale(locale) do
              @object.public_send("#{key}=", value)
            end
          end
        end
        @object.save
        flash[:success] = Spree.t('notice_messages.translations_saved')
        # TODO there should be a better way to redirect
        @object.instance_of?(Spree::Taxon) ? redirect_to_taxon_edit_page : redirect_to(edit_polymorphic_path([:admin, @object]))
      end

      def redirect_to_taxon_edit_page
        redirect_to spree.edit_admin_taxonomy_taxon_path(@object.taxonomy, @object.id)
      end
    end
  end
end
