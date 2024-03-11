module Spree
  module Admin
    class ErrorsController < BaseController
      skip_before_action :authorize_admin
      skip_before_action :ensure_can_read_admin_panel

      def forbidden
        render status: 403 if ensure_can_read_admin_panel
      end

      def access_denied
        render status: 403, layout: nil
      end
    end
  end
end
