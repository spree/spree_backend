module Spree
  module Admin
    class StoresController < Spree::Admin::BaseController
      before_action :load_store, only: [:new, :edit, :update]
      before_action :set_default_currency, only: :new
      before_action :set_default_locale, only: :new
      before_action :normalize_supported_currencies, only: [:create, :update]
      before_action :normalize_supported_locales, only: [:create, :update]
      before_action :set_default_country_id, only: :new
      before_action :load_all_countries, only: [:new, :edit, :update, :create]
      before_action :load_all_zones, only: [:new, :edit, :update, :create]

      def index
        if params[:ids]
          load_stores_by_ids
        elsif params[:q]
          load_stores_by_query
        end

        respond_with(@stores) do |format|
          format.json { render layout: false }
        end
      end

      def load_stores_by_ids
        @stores = stores_scope.where(id: params[:ids].split(','))
      end

      def load_stores_by_query
        @stores = if defined?(SpreeGlobalize)
                    stores_scope.joins(:translations).where("LOWER(#{Store::Translation.table_name}.name) LIKE LOWER(:query)",
                                                            query: "%#{params[:q]}%")
                  else
                    stores_scope.where('LOWER(name) LIKE LOWER(:query)', query: "%#{params[:q]}%")
                  end
      end

      def create
        @store = stores_scope.new(permitted_store_params)

        if @store.save
          flash[:success] = flash_message_for(@store, :successfully_created)
          redirect_to @store.formatted_url + spree.admin_stores_path
        else
          flash[:error] = "#{Spree.t('store_errors.unable_to_create')}: #{@store.errors.full_messages.join(', ')}"
          render :new, status: :unprocessable_entity
        end
      end

      def update
        @store.assign_attributes(permitted_store_params)

        if @store.save
          flash[:success] = flash_message_for(@store, :successfully_updated)
          redirect_to spree.admin_stores_path
        else
          flash[:error] = "#{Spree.t('store_errors.unable_to_update')}: #{@store.errors.full_messages.join(', ')}"
          redirect_to spree.edit_admin_store_path(@store)
        end
      end

      def destroy
        @store = stores_scope.find(params[:id])

        if @store.destroy
          flash[:success] = flash_message_for(@store, :successfully_removed)
          respond_with(@store) do |format|
            format.html { redirect_to spree.admin_stores_path }
            format.js { render_js_for_destroy }
          end
        else
          render plain: "#{Spree.t('store_errors.unable_to_delete')}: #{@store.errors.full_messages.join(', ')}", status: :unprocessable_entity
        end
      end

      def set_default
        store = stores_scope.find(params[:id])
        stores = stores_scope.where.not(id: params[:id])

        ApplicationRecord.transaction do
          store.update(default: true)
          stores.update_all(default: false)
        end

        if store.errors.empty?
          flash[:success] = Spree.t(:store_set_as_default, store: store.name)
        else
          flash[:error] = "#{Spree.t(:store_not_set_as_default, store: store.name)} #{store.errors.full_messages.join(', ')}"
        end

        redirect_to spree.admin_stores_path
      end

      protected

      def permitted_store_params
        params.require(:store).permit(permitted_store_attributes)
      end

      private

      def load_store
        @store = stores_scope.find_by(id: params[:id]) || stores_scope.new
      end

      def load_all_countries
        @countries = Spree::Country.all
      end

      def load_all_zones
        @zones = Spree::Zone.pluck(:name, :id)
      end

      def set_default_currency
        @store.default_currency = Spree::Store.default.default_currency
      end

      def set_default_locale
        @store.default_locale = I18n.locale
      end

      def normalize_supported_currencies
        if params[:store][:supported_currencies]&.is_a?(Array)
          params[:store][:supported_currencies] = params[:store][:supported_currencies].compact.uniq.reject(&:blank?).join(',')
        end
      end

      def normalize_supported_locales
        if params[:store][:supported_locales]&.is_a?(Array)
          params[:store][:supported_locales] = params[:store][:supported_locales].compact.uniq.reject(&:blank?).join(',')
        end
      end

      def set_default_country_id
        @store.default_country_id = Spree::Config[:default_country_id]
      end
    end
  end
end
