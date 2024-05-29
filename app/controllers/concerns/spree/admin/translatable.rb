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
        translation_params = params[:translation].permit!.to_h

        current_store_locales = current_store.supported_locales_list
        params_locales = translation_params.flat_map { |_attribute, translations| translations.compact_blank.keys }
        locales_to_update = current_store_locales & params_locales

        locales_to_update.each do |locale|
          if update_translation_value?(locale)
            translation = @object.translations.find_or_initialize_by(locale: locale)
            translation_params.each do |attribute, translations|
              translation.public_send("#{attribute}=", translations[locale])
            end
            translation.save!
          else
            Mobility.with_locale(locale) do
              translation_params.each do |attribute, translations|
                @object.public_send("#{attribute}=", translations[locale])
              end
              @object.save!
            end
          end
        end
      end

      def update_translation_value?(locale)
        Spree.always_use_translations? || I18n.default_locale.to_s != locale
      end
    end
  end
end
