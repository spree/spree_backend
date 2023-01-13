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
        params[:translation].each do |key, translation|
          translation.each do |locale, value|
            I18n.with_locale(locale) do
              @object.public_send("#{key}=", value)
            end
          end
        end

        @object.save
      end
    end
  end
end
