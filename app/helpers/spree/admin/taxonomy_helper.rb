module Spree
  module Admin
    module TaxonomyHelper
      def taxonomy_item_bar(taxonomy, taxon)
        render 'spree/admin/shared/tree/taxonomy', taxonomy: taxonomy, taxon: taxon
      end

      def build_taxonomy_tree(taxonomy, taxon)
        descendants = []

        unless taxon.leaf?
          taxon.children.each do |child_item|
            descendants << build_taxonomy_tree(taxonomy, child_item) unless taxon.leaf?
          end
        end

        info_row = taxonomy_item_bar(taxonomy, taxon)
        item_container = content_tag(:div, raw(descendants.join), data: { sortable_tree_parent_id_value: taxon.id })

        content_tag(:div, info_row + item_container,
                    class: 'sortable-tree-item draggable removable-dom-element',
                    data: {
                      sortable_tree_resource_name_value: 'taxon',
                      sortable_tree_update_url_value: "/api/v2/platform/taxons/#{taxon.id}/reposition"
                    })
      end
    end
  end
end
