module Spree
  module Admin
    class PublicMetadataController < BaseController
      include Spree::Admin::MetadataConcern

      before_action :find_resource

      def create
        # Create a new JSON key value pair on public_metadata column for the @object
        # Force key to be down-case separated with dot.notation, this seems to be the standard.
      end

      def update
        assert_metadata(@object) # Swap this out for a simple key value pairs, this is here just for testing this works.
                                 # Is it possible to update the key? By changing the key we are changing the ID
                                 # of the target we are operating on, this needs consideration.
        @object.save!

        respond_with(@object) do |format|
          format.html { redirect_to '/admin' } # Swap this for turbo stream to render in place
                                               # It will be much easier than trying to redirect
                                               # to the correct location for each metadata type
                                               # Order, Address, Variant, Product.....
        end
      end

      def delete
        @object.public_metadata.delete(key.to_sym)
        @object.save!
      end

      private

      def find_resource
        model_klazz = params[:klazz_name].constantize # Because this is to be reusable across many different resources.
        @object = model_klazz.find(params[:id])
      end

      def format_key
        # Use this method to format the key for use on api requests -> dot.notation seems standard
      end
    end
  end
end
