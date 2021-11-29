module Spree
  module Admin
    class ProductsController < ResourceController
      include Spree::Admin::ProductConcern

      helper 'spree/products'

      before_action :load_data, except: :index

      create.before :create_before
      update.before :update_before
      helper_method :clone_object_url

      def show
        session[:return_to] ||= request.referer
        redirect_to action: :edit
      end

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def update
        if params[:product][:taxon_ids].present?
          params[:product][:taxon_ids] = params[:product][:taxon_ids].reject(&:empty?)
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].reject(&:empty?)
        end
        invoke_callbacks(:update, :before)
        if @object.update(permitted_resource_params)
          set_current_store
          invoke_callbacks(:update, :after)
          flash[:success] = flash_message_for(@object, :successfully_updated)
          respond_with(@object) do |format|
            format.html { redirect_to location_after_save }
            format.js { render layout: false }
          end
        else
          # Stops people submitting blank slugs, causing errors when they try to
          # update the product again
          @product.slug = @product.slug_was if @product.slug.blank?
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @product = product_scope.friendly.find(params[:id])

        begin
          # TODO: why is @product.destroy raising ActiveRecord::RecordNotDestroyed instead of failing with false result
          if @product.destroy
            flash[:success] = Spree.t('notice_messages.product_deleted')
          else
            flash[:error] = Spree.t('notice_messages.product_not_deleted', error: @product.errors.full_messages.to_sentence)
          end
        rescue ActiveRecord::RecordNotDestroyed => e
          flash[:error] = Spree.t('notice_messages.product_not_deleted', error: e.message)
        end

        respond_with(@product) do |format|
          format.html { redirect_to collection_url }
          format.js { render_js_for_destroy }
        end
      end

      def clone
        @new = @product.duplicate

        if @new.persisted?
          flash[:success] = Spree.t('notice_messages.product_cloned')
          redirect_to spree.edit_admin_product_url(@new)
        else
          flash[:error] = Spree.t('notice_messages.product_not_cloned', error: @new.errors.full_messages.to_sentence)
          redirect_to spree.admin_products_url
        end
      rescue ActiveRecord::RecordInvalid => e
        # Handle error on uniqueness validation on product fields
        flash[:error] = Spree.t('notice_messages.product_not_cloned', error: e.message)
        redirect_to spree.admin_products_url
      end

      def stock
        @variants = @product.variants.includes(*variant_stock_includes)
        @variants = [@product.master] if @variants.empty?
        @stock_locations = StockLocation.accessible_by(current_ability)
        if @stock_locations.empty?
          flash[:error] = Spree.t(:stock_management_requires_a_stock_location)
          redirect_to spree.admin_stock_locations_path
        end
      end

      protected

      def find_resource
        product_scope.with_deleted.friendly.find(params[:id])
      end

      def location_after_save
        spree.edit_admin_product_url(@product)
      end

      def load_data
        @taxons = Taxon.order(:name)
        @option_types = OptionType.order(:name)
        @tax_categories = TaxCategory.order(:name)
        @shipping_categories = ShippingCategory.order(:name)
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= '1'
        params[:q][:not_discontinued] ||= '1'

        params[:q][:s] ||= 'name asc'

        @collection = product_scope

        # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
        # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
        if params[:q][:deleted_at_null] == '0'
          @collection = @collection.with_deleted
        end
        # @search needs to be defined as this is passed to search_form_for
        # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
        # This is to include all products and not just deleted products.
        @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
        @collection = @search.result.
                      includes(product_includes).
                      page(params[:page]).
                      per(params[:per_page] || Spree::Backend::Config[:admin_products_per_page])
        @collection
      end

      def create_before
        return if params[:product][:prototype_id].blank?

        @prototype = Spree::Prototype.find(params[:product][:prototype_id])
      end

      def update_before
        # NOTE: we only reset the product properties if we're receiving a post
        #       from the form on that tab
        return unless params[:clear_product_properties]

        params[:product] ||= {}
      end

      def product_includes
        {
          variant_images: [],
          tax_category: [],
          master: [],
          variants: [:prices]
        }
      end

      def clone_object_url(resource)
        clone_admin_product_url resource
      end

      private

      def variant_stock_includes
        [:images, stock_items: :stock_location, option_values: :option_type]
      end
    end
  end
end
