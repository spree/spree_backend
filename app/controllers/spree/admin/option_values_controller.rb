module Spree
  module Admin
    class OptionValuesController < ResourceController
      include Translatable

      # This method is added here to allow `edit_polymorphic_path` to work
      def edit_admin_option_value_path(option_value)
        spree.edit_admin_option_type_url(option_value.option_type)
      end

      def destroy
        option_value = Spree::OptionValue.find(params[:id])
        option_value.destroy
        render plain: nil
      end
    end
  end
end
