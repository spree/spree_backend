$.fn.taxonAutocomplete = function() {
  'use strict'

  function formatTaxonList(values) {
    return values.map(function (obj) {
      return {
        id: obj.id,
        text: obj.attributes.pretty_name
      }
    })
  }

  this.select2({
    multiple: true,
    placeholder: Spree.translations.taxon_placeholder,
    minimumInputLength: 2,
    ajax: {
      url: Spree.routes.taxons_api_v2,
      dataType: 'json',
      data: function (params) {
        return {
          filter: {
            name_cont: params.term
          },
          fields: {
            taxon: 'pretty_name'
          }
        }
      },
      headers: Spree.apiV2Authentication(),
      processResults: function(data) {
        return {
          results: formatTaxonList(data.data)
        }
      }
    }
  })
}

document.addEventListener("spree:load", function() {
  var productTaxonSelector = document.getElementById('product_taxon_ids')
  if (productTaxonSelector == null) return
  if (productTaxonSelector.hasAttribute('data-autocomplete-url-value')) return

  $('#product_taxon_ids').taxonAutocomplete()
})
