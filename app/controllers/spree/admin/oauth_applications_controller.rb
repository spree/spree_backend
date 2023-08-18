module Spree
  module Admin
    class OauthApplicationsController < ResourceController
      before_action :set_default_scopes, only: [:new, :edit]

      def index
        flash.now[:notice] = Spree.t('admin.oauth_applications.documentation_message').html_safe
      end

      private

      def create_turbo_stream_enabled?
        true
      end

      def set_default_scopes
        @object.scopes = 'admin' if @object.scopes.blank?
      end
    end
  end
end
