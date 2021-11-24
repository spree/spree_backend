module Spree
  module Admin
    module MenuHelper
      def default_menu_for_store?(menu)
        menu.store.default_locale == menu.locale
      end
    end
  end
end
