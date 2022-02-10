module Spree
  module Admin
    class DashboardController < BaseController
      def show
        @products_added = current_store.products.any?
        @shipping_methods_added = Spree::ShippingMethod.any?
        @payment_methods_added = current_store.payment_methods.any?
        @taxes_added = Spree::TaxRate.any?

        @onboarding_complete = @products_added && @shipping_methods_added && @payment_methods_added && @taxes_added

        @shippable_countries = Spree::ShippingMethod.all.collect(&:zones).flatten.uniq.compact.collect(&:countries).flatten.uniq.sort_by(&:name)

        @active_tab = if !@products_added
                        'products'
                      elsif !@shipping_methods_added
                        'shipping'
                      elsif !@payment_methods_added
                        'payment'
                      else
                        'taxes'
                      end
      end
    end
  end
end
