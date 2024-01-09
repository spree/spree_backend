module Spree
  module Admin
    class ErrorsController < BaseController

      skip_before_action :authorize_admin

      def forbidden
        authorize! :read, ::Spree::AdminPanel
        render status: 403
      end

      rescue_from CanCan::AccessDenied do |_exception|
        throw _exception
      end
    end
  end
end
