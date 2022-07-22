module Spree
  module Admin
    module ProductConcern
      extend ActiveSupport::Concern

      def product_scope
        current_store.products.accessible_by(current_ability, :index)
                     .joins(:translations).where(spree_product_translations: { locale: I18n.locale })
      end
    end
  end
end
