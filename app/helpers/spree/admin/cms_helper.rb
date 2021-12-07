module Spree
  module Admin
    module CmsHelper
      def cms_page_locale(page)
        return if page.locale == current_store.default_locale

        page.locale
      end
    end
  end
end
