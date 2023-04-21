module Spree
  module Admin
    module ProductConcern
      extend ActiveSupport::Concern

      def product_scope
        current_store.products.accessible_by(current_ability, :index).includes(:translations)
      end
    end
  end
end
