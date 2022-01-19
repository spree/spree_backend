module Spree
  module Admin
    module ProductsHelper
      # will return a human readable string
      def available_status(product)
        return Spree.t('admin.product.archived') if product.status == 'archived'
        return Spree.t('admin.product.deleted') if product.deleted?

        if product.available?
          Spree.t('admin.product.active')
        elsif product.available_on&.future?
          Spree.t('admin.product.pre_order')
        else
          Spree.t('admin.product.draft')
        end
      end
    end
  end
end
