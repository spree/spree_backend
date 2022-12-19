module Spree
  module Admin
    class TaxonomiesController < TranslatableResourceController
      private

      def location_after_save
        if @taxonomy.previously_new_record?
          edit_admin_taxonomy_url(@taxonomy)
        else
          admin_taxonomies_url
        end
      end
    end
  end
end
