/* global variantLineItemTemplate, order_number, order_id */
// This file contains the code for interacting with line items in the manual cart
$(document).ready(function () {
  'use strict'

  // handle variant selection, show stock level.
  $('#add_line_item_variant_id').change(function () {
    var variantId = $(this).val().toString()

    var variant = _.find(window.variants, function (variant) {
      // eslint-disable-next-line eqeqeq
      return variant.id.toString() == variantId
    })
    $('#stock_details').html(variantLineItemTemplate({ variant: variant }))
    $('#stock_details').show()
    $('button.add_variant').click(addVariant)
  })
})

function addVariant () {
  $('#stock_details').hide()
  var variantId = $('select.variant_autocomplete').val()
  var quantity = $('input#variant_quantity').val()

  adjustLineItems(order_id, variantId, quantity)
  return 1
}

adjustLineItems = function(order_id, variant_id, quantity){
  $.ajax({
    type: 'POST',
    url: Spree.routes.line_items_api_v2,
    data: {
      line_item: {
        order_id: order_id,
        variant_id: variant_id,
        quantity: quantity
      }
    },
    headers: Spree.apiV2Authentication()
  }).done(function () {
      window.Spree.advanceOrder()
      window.location.reload()
  }).fail(function (msg) {
    if (typeof msg.responseJSON.message != 'undefined') {
      alert(msg.responseJSON.message)
    } else {
      alert(msg.responseJSON.exception)
    }
  })
}
