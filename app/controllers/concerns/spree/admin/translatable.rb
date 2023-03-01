module Spree
  module Admin
    module Translatable
      extend ActiveSupport::Concern

      def edit_translations
        save_translation_values
        flash[:success] = Spree.t('notice_messages.translations_saved')

        redirect_to(edit_polymorphic_path([:admin, @object]))
      end

      private

      def save_translation_values
        translation_params = params[:translation]

        current_store.supported_locales_list.each do |locale|
          I18n.with_locale(locale) do
            translation_params.each do |attribute, translations|
              @object.public_send("#{attribute}=", translations[locale])
            end
            @object.save!
          end
        end
      end
    end
  end
end
