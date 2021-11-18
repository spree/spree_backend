$.fn.productAutocomplete = function (options) {
  'use strict'

  // Default options
  options = options || {}
  var multiple = typeof (options.multiple) !== 'undefined' ? options.multiple : true
  var values = typeof (options.values) !== 'undefined' ? options.values : null

  function addOptions(select, values) {
    $.ajax({
      url: Spree.routes.products_api_v2,
      dataType: 'json',
      data: {
        filter: {
          id_in: values
        },
        fields: {
          product: 'name'
        }
      },
      headers: Spree.apiV2Authentication(),
    }).then(function (data) {
      select.addSelect2Options(data.data)
    })
  }

  this.select2({
    multiple: multiple,
    minimumInputLength: 3,
    ajax: {
      url: Spree.routes.products_api_v2,
      dataType: 'json',
      data: function (params) {
        return {
          filter: {
            name_or_master_sku_cont: params.term
          },
          fields: {
            product: 'name'
          }
        }
      },
      headers: Spree.apiV2Authentication(),
      processResults: function(data) {
        return formatSelect2Options(data)
      }
    }
  })

  if (values) {
    addOptions(this, values)
  }
}

document.addEventListener("spree:load", function() {
  $('.product_picker').productAutocomplete()
})
