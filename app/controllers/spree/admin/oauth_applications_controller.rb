module Spree
  module Admin
    class OauthApplicationsController < ResourceController
      before_action :set_default_scopes, only: [:new, :edit]

      private

      def turbo_enabled?
        true
      end

      def set_default_scopes
        @object.scopes = 'admin' if @object.scopes.blank?
      end
    end
  end
end
