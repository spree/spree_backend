/* global variantTemplate */
document.addEventListener("spree:load", function() {
  var el = $('#stock_movement_stock_item_id')
  var jsonApiVariants = {}
  el.select2({
    placeholder: 'Find a stock item', // translate
    minimumInputLength: 3,
    quietMillis: 200,
    ajax: {
      url: Spree.routes.stock_items_api_v2,
      data: function (params, page) {
        return {
          filter: {
            variant_product_name_cont: params.term,
            stock_location_id_eq: el.data('stock-location-id')
          },
          include: 'variant',
          image_transformation: {
            size: '100x100'
          },
          fields: {
            'variant': 'name,sku,options_text,images'
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
          return {
            id: stockItem.id,
            text: stockItem.variant.name,
            variant: stockItem.variant
          }
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
    templateResult: function (stockItem) {
      if (stockItem.loading) {
        return stockItem.text
      }

      let variant = stockItem.variant
      if (variant['images'][0] !== undefined && variant['images'][0].transformed_url !== undefined) {
        variant.image = variant.images[0].transformed_url
      }
      return $(variantTemplate({
        variant: variant
      }))
    },
    templateSelection: function(stockItem) {
      const variant = stockItem.variant
      if (variant === undefined) {
        return stockItem.text
      } else if (!!variant.options_text && variant.options_text !== '') {
        return variant.name + '(' + variant.options_text + ')'
      } else {
        return variant.name
      }
    }
  })
})
