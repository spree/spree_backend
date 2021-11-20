module Spree
  module Admin
    class DashboardController < BaseController
      # this is temporary until we develop our dashboard screen
      def show
        redirect_to spree.admin_orders_url
      end
    end
  end
end