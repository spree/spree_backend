module Spree
  module Admin
    class TemplatePromotionsController < ResourceController
      before_action :load_data

      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        @object.template = true
        if @object.save
          invoke_callbacks(:create, :after)
          flash[:success] = flash_message_for(@object, :successfully_created)
          respond_with(@object) do |format|
            format.turbo_stream if create_turbo_stream_enabled?
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end
        else
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new, status: :unprocessable_entity }
            format.js { render layout: false, status: :unprocessable_entity }
          end
        end
      end

      private

      def new_object_url(options = {})
        spree.new_admin_template_promotion_url(options)
      end

      def collection_url(options = {})
        spree.admin_template_promotions_url(options)
      end

      def resource
        return @resource if @resource

        parent_model_name = parent_data[:model_name] if parent_data
        @resource = Spree::Admin::Resource.new 'admin/spree', 'template_promotions', parent_model_name, object_name
      end

      def load_data
        @actions = Rails.application.config.spree.promotions.actions

        @calculators = Rails.application.config.spree.calculators.promotion_actions_create_adjustments
        @promotion_categories = Spree::PromotionCategory.order(:name)
        @promotion = @object
      end

      def collection
        return @collection if defined?(@collection)

        params[:q] ||= HashWithIndifferentAccess.new
        params[:q][:s] ||= 'id desc'

        @collection = super
        @collection = @collection.templates
        @search = @collection.ransack(params[:q])
        @collection = @search.result(distinct: true).
          includes(promotion_includes).
          page(params[:page]).
          per(params[:per_page] || Spree::Backend::Config[:admin_promotions_per_page])

        @promotions = @collection
      end

      def promotion_includes
        [:promotion_actions, :promotions_from_template]
      end

      def model_class
        Spree::Promotion
      end

      def permitted_resource_params
        params.require(:promotion).permit!
      end
    end
  end
end
