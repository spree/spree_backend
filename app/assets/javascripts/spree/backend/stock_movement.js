/* global variantTemplate */
document.addEventListener("spree:load", function() {
  var el = $('#stock_movement_stock_item_id')
  var jsonApiVariants = {}
  el.select2({
    placeholder: 'Find a stock item', // translate
    ajax: {
      url: Spree.routes.stock_items_api_v2,
      data: function (term, page) {
        return {
          filter: {
            variant_product_name_cont: term,
            stock_location_id_eq: el.data('stock-location-id')
          },
          fields: {
            'variant': 'name,sku,options_text'
          },
          per_page: 50,
          page: page
        }
      },
      headers: Spree.apiV2Authentication(),
      success: function(data) {
        var JSONAPIDeserializer = require('jsonapi-serializer').Deserializer
        new JSONAPIDeserializer({ keyForAttribute: 'snake_case' }).deserialize(data, function (_err, variants) {
          jsonApiVariants = variants
        })
      },
      processResults: function (json) {
        var res = jsonApiVariants.map(function (stockItem) {
          return formattedVariantList(stockItem.variant)
        })

        return {
          results: res
        }
      },
      results: function (data, page) {
        var more = (page * 50) < data.count
        return {
          results: data.stock_items,
          more: more
        }
      }
    },
    formatResult: function (stockItem) {
      return variantTemplate({
        variant: stockItem.variant
      })
    },
    formatSelection: function (stockItem) {
      return Select2.util.escapeMarkup(stockItem.variant.name + '(' + stockItem.variant.options_text + ')')
    }
  })
})
