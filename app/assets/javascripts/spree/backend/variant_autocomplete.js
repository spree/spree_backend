/* global variantTemplate */
// variant autocompletion
document.addEventListener("spree:load", function() {
  var variantAutocompleteTemplate = $('#variant_autocomplete_template')
  if (variantAutocompleteTemplate.length > 0) {
    window.variantTemplate = Handlebars.compile(variantAutocompleteTemplate.text())
    window.variantStockTemplate = Handlebars.compile($('#variant_autocomplete_stock_template').text())
    window.variantLineItemTemplate = Handlebars.compile($('#variant_line_items_autocomplete_stock_template').text())
  }
})

function formatVariantResult(variant) {
  if (variant.loading) {
    return variant.text
  }

  if (variant['images'][0] !== undefined && variant['images'][0].transformed_url !== undefined) {
    variant.image = variant.images[0].transformed_url
  }
  return $(variantTemplate({
    variant: variant
  }))
}

$.fn.variantAutocomplete = function () {

  // deal with initSelection
  return this.select2({
    placeholder: Spree.translations.variant_placeholder,
    minimumInputLength: 3,
    quietMillis: 200,
    ajax: {
      url: Spree.url(Spree.routes.variants_api_v2),
      dataType: 'json',
      data: function (params) {
        var query = {
          filter: {
            search_by_product_name_or_sku: params.term
          },
          include: 'images,stock_items.stock_location',
          image_transformation: {
            size: '100x100'
          }
        }

        return query;
      },
      headers: Spree.apiV2Authentication(),
      success: function(data) {
        var JSONAPIDeserializer = require('jsonapi-serializer').Deserializer
        new JSONAPIDeserializer({ keyForAttribute: 'snake_case' }).deserialize(data, function (_err, variants) {
          jsonApiVariants = variants
          window.variants = variants
        })
      },
      processResults: function (_data) {
        return { results: jsonApiVariants } // we need to return deserialized json api data
      }
    },
    templateResult: formatVariantResult,
    templateSelection: function(variant) {
      if (!!variant.options_text) {
        return variant.name + '(' + variant.options_text + ')'
      } else {
        return variant.name
      }
    }
  })

}
