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
        redirect_to spree.edit_admin_product_url(@object)
      end

    end
  end
end
