/* global shipments, variantStockTemplate, order_number, order_id */
// Shipments AJAX API
document.addEventListener("spree:load", function() {
  'use strict'

  // handle variant selection, show stock level.
  $('#add_variant_id').change(function () {
    var variantId = $(this).val().toString()
    var variant = _.find(window.variants, function (variant) {
      return variant.id.toString() === variantId
    })

    $('#stock_details').html(variantStockTemplate({ variant: variant }))
    $('#stock_details').show()

    $('button.add_variant').click(addVariantFromStockLocation)
  })

  // handle edit click
  $('a.edit-item').click(toggleItemEdit)

  // handle cancel click
  $('a.cancel-item').click(toggleItemEdit)

  // handle split click
  $('a.split-item').click(startItemSplit)

  // handle save click
  $('a.save-item').click(function () {
    var save = $(this)
    var shipmentNumber = save.data('shipment-number')
    var variantId = save.data('variant-id')

    var quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val())

    toggleItemEdit()
    adjustShipmentItems(shipmentNumber, variantId, quantity)
    return false
  })

  // handle delete click
  $('a.delete-item').click(function (event) {
    if (confirm(Spree.translations.are_you_sure_delete)) {
      var del = $(this)
      var shipmentNumber = del.data('shipment-number')
      var variantId = del.data('variant-id')
      // eslint-disable-next-line
      var url = Spree.routes.shipments_api_v2 + '/' + shipmentNumber + '/remove_item'

      toggleItemEdit()

      $.ajax({
        type: 'PATCH',
        url: Spree.url(url),
        data: {
          shipment: {
            variant_id: variantId
          }
        },
        headers: Spree.apiV2Authentication()
      }).done(function (msg) {
        window.location.reload()
      }).fail(function (msg) {
        alert(msg.responseJSON.error)
      })
    }
    return false
  })

  // handle ship click
  $('[data-hook=admin_shipment_form] a.ship').on('click', function () {
    var link = $(this)
    var url = Spree.url(Spree.routes.shipments_api_v2 + '/' + link.data('shipment-number') + '/ship')
    $.ajax({
      type: 'PATCH',
      url: url,
      headers: Spree.apiV2Authentication()
    }).done(function () {
      window.location.reload()
    }).fail(function (msg) {
      alert(msg.responseJSON.error)
    })
  })

  // handle shipping method edit click
  $('a.edit-method').click(toggleMethodEdit)
  $('a.cancel-method').click(toggleMethodEdit)

  // handle shipping method save
  $('[data-hook=admin_shipment_form] a.save-method').on('click', function (event) {
    event.preventDefault()

    var link = $(this)
    var shipmentNumber = link.data('shipment-number')
    var selectedShippingRateId = link.parents('tbody').find("select#selected_shipping_rate_id[data-shipment-number='" + shipmentNumber + "']").val()
    var unlock = link.parents('tbody').find("input[name='open_adjustment'][data-shipment-number='" + shipmentNumber + "']:checked").val()
    var url = Spree.url(Spree.routes.shipments_api_v2 + '/' + shipmentNumber + '.json')

    $.ajax({
      type: 'PATCH',
      url: url,
      data: {
        shipment: {
          selected_shipping_rate_id: selectedShippingRateId,
          unlock: unlock
        },
      },
      headers: Spree.apiV2Authentication()
    }).done(function () {
      window.location.reload()
    }).fail(function (msg) {
      alert(msg.responseJSON.error)
    })
  })

  function toggleTrackingEdit(event) {
    event.preventDefault()

    var link = $(this)
    link.parents('tbody').find('tr.edit-tracking').toggle()
    link.parents('tbody').find('tr.show-tracking').toggle()
  }

  // handle tracking edit click
  $('a.edit-tracking').click(toggleTrackingEdit)
  $('a.cancel-tracking').click(toggleTrackingEdit)

  function createTrackingValueContent(data) {
    if (data.attributes.tracking_url && data.attributes.tracking) {
      return '<a target="_blank" href="' + data.attributes.tracking_url + '">' + data.attributes.tracking + '<a>'
    }

    return data.attributes.tracking
  }

  // handle tracking save
  $('[data-hook=admin_shipment_form] a.save-tracking').on('click', function (event) {
    event.preventDefault()

    var link = $(this)
    var shipmentNumber = link.data('shipment-number')
    var tracking = link.parents('tbody').find('input#tracking').val()
    var url = Spree.url(Spree.routes.shipments_api_v2 + '/' + shipmentNumber + '.json')

    $.ajax({
      type: 'PATCH',
      url: url,
      data: {
        shipment: {
          tracking: tracking
        }
      },
      headers: Spree.apiV2Authentication()
    }).done(function (json) {
      link.parents('tbody').find('tr.edit-tracking').toggle()

      var show = link.parents('tbody').find('tr.show-tracking')
      show.toggle()

      if (json.data.attributes.tracking) {
        show.find('.tracking-value').html($('<strong>').html(Spree.translations.tracking + ': ')).append(createTrackingValueContent(json.data))
      } else {
        show.find('.tracking-value').html(Spree.translations.no_tracking_present)
      }
    })
  })
})

function adjustShipmentItems(shipmentNumber, variantId, quantity) {
  var shipment = _.findWhere(shipments, { number: shipmentNumber + '' })
  var inventoryUnits = _.where(shipment.inventory_units, { variant_id: variantId })
  var url = Spree.routes.shipments_api_v2 + '/' + shipmentNumber
  var previousQuantity = inventoryUnits.reduce(function (accumulator, currentUnit, _index, _array) {
    return accumulator + currentUnit.quantity
  }, 0)
  var newQuantity = 0

  if (previousQuantity < quantity) {
    url += '/add_item'
    newQuantity = (quantity - previousQuantity)
  } else if (previousQuantity > quantity) {
    url += '/remove_item'
    newQuantity = (previousQuantity - quantity)
  }
  url += '.json'

  if (newQuantity !== 0) {
    $.ajax({
      type: 'PATCH',
      url: Spree.url(url),
      data: {
        shipment: {
          variant_id: variantId,
          quantity: newQuantity,
        }
      },
      headers: Spree.apiV2Authentication()
    }).done(function (msg) {
      window.location.reload()
    }).fail(function (msg) {
      alert(msg.responseJSON.error)
    })
  }
}

function toggleMethodEdit() {
  var link = $(this)
  link.parents('tbody').find('tr.edit-method').toggle()
  link.parents('tbody').find('tr.show-method').toggle()

  return false
}

function toggleItemEdit() {
  var link = $(this)
  var linkParent = link.parent()
  linkParent.find('a.edit-item').toggle()
  linkParent.find('a.cancel-item').toggle()
  linkParent.find('a.split-item').toggle()
  linkParent.find('a.save-item').toggle()
  linkParent.find('a.delete-item').toggle()
  link.parents('tr').find('td.item-qty-show').toggle()
  link.parents('tr').find('td.item-qty-edit').toggle()

  return false
}

function startItemSplit(event) {
  event.preventDefault()
  $('.cancel-split').each(function () {
    $(this).click()
  })
  var link = $(this)
  link.parent().find('a.edit-item').toggle()
  link.parent().find('a.split-item').toggle()
  link.parent().find('a.delete-item').toggle()
  var variantId = link.data('variant-id')

  var variant = {}
  $.ajax({
    type: 'GET',
    async: false,
    url: Spree.routes.variants_api_v2 + '/' + variantId,
    data: {
      include: 'stock_items.stock_location'
    },
    headers: Spree.apiV2Authentication()
  }).done(function (json) {
    var JSONAPIDeserializer = require('jsonapi-serializer').Deserializer
    new JSONAPIDeserializer({ keyForAttribute: 'snake_case' }).deserialize(json, function (_err, deserializedJson) {
      variant = deserializedJson

      var maxQuantity = link.closest('tr').data('item-quantity')
      var splitItemTemplate = Handlebars.compile($('#variant_split_template').text())

      link.closest('tr').after(splitItemTemplate({ variant: variant, shipments: shipments, max_quantity: maxQuantity }))
      $('a.cancel-split').click(cancelItemSplit)
      $('a.save-split').click(completeItemSplit)

      $('#item_stock_location').select2({ width: 'resolve', placeholder: Spree.translations.item_stock_placeholder })
    })
  }).fail(function (msg) {
    alert(msg.responseJSON.error)
  })
}

function completeItemSplit(event) {
  event.preventDefault()

  if ($('#item_stock_location').val() === '') {
    alert('Please select the split destination.')
    return false
  }

  var link = $(this)
  var stockItemRow = link.closest('tr')
  var variantId = stockItemRow.data('variant-id')
  var quantity = stockItemRow.find('#item_quantity').val()

  var stockLocationId = stockItemRow.find('#item_stock_location').val()
  var originalShipmentNumber = link.closest('tbody').data('shipment-number')

  var selectedShipment = stockItemRow.find('#item_stock_location option:selected')
  var targetShipmentNumber = selectedShipment.data('shipment-number')
  var newShipment = selectedShipment.data('new-shipment')

  // eslint-disable-next-line eqeqeq
  if (stockLocationId != 'new_shipment') {
    var path, additionalData
    if (newShipment !== undefined) {
      // transfer to a new location data
      path = '/transfer_to_location'
      additionalData = { stock_location_id: stockLocationId }
    } else {
      // transfer to an existing shipment data
      path = '/transfer_to_shipment'
      additionalData = { target_shipment_number: targetShipmentNumber }
    }

    var data = {
      variant_id: variantId,
      quantity: quantity
    }

    $.ajax({
      type: 'PATCH',
      async: false,
      url: Spree.url(Spree.routes.shipments_api_v2 + '/' + originalShipmentNumber + path),
      data: {
        shipment: $.extend(data, additionalData)
      },
      headers: Spree.apiV2Authentication()
    }).fail(function (msg) {
      alert(msg.responseJSON.error)
    }).done(function (msg) {
      window.location.reload()
    })
  }
}

function cancelItemSplit(event) {
  event.preventDefault()
  var link = $(this)
  var prevRow = link.closest('tr').prev()
  link.closest('tr').remove()
  prevRow.find('a.edit-item').toggle()
  prevRow.find('a.split-item').toggle()
  prevRow.find('a.delete-item').toggle()
}

function addVariantFromStockLocation(event) {
  event.preventDefault()

  $('#stock_details').hide()

  var variantId = $('select.variant_autocomplete').val()
  var stockLocationId = $(this).data('stock-location-id')
  var quantity = $("input.quantity[data-stock-location-id='" + stockLocationId + "']").val()

  var shipment = _.find(shipments, function (shipment) {
    return shipment.stock_location_id === stockLocationId && (shipment.state === 'ready' || shipment.state === 'pending')
  })

  if (shipment === undefined) {
    $.ajax({
      type: 'POST',
      // eslint-disable-next-line camelcase
      url: Spree.routes.shipments_api_v2,
      data: {
        shipment: {
          order_id: order_id,
          variant_id: variantId,
          quantity: quantity,
          stock_location_id: stockLocationId
        }
      },
      headers: Spree.apiV2Authentication()
    }).done(function (msg) {
      window.location.reload()
    }).fail(function (msg) {
      alert(msg.responseJSON.error)
    })
  } else {
    // add to existing shipment
    adjustShipmentItems(shipment.number, variantId, quantity)
  }
  return 1
}
