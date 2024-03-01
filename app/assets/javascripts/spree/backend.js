//= require purify
//= require sortable
//= require jquery3
//= require handlebars
//= require cleave
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require select2-full
//= require sweetalert2
//= require tinymce
//= require underscore-min.js
//= require jsonapi-serializer.min
//= require popper
//= require bootstrap-sprockets
//= require flatpickr

//= require spree/backend/global/_index

//= require spree
//= require spree/backend/spree-select2
//= require spree/backend/address_states
//= require spree/backend/adjustments
//= require spree/backend/admin
//= require spree/backend/calculator
//= require spree/backend/checkouts/edit
//= require spree/backend/gateway
//= require spree/backend/handlebar_extensions
//= require spree/backend/line_items
//= require spree/backend/line_items_on_order_edit
//= require spree/backend/multi_currency
//= require spree/backend/option_type_autocomplete
//= require spree/backend/option_value_picker
//= require spree/backend/orders/edit
//= require spree/backend/payments/edit
//= require spree/backend/payments/new
//= require spree/backend/product_picker
//= require spree/backend/progress
//= require spree/backend/promotions
//= require spree/backend/cms/_index
//= require spree/backend/menus/_index
//= require spree/backend/returns/expedited_exchanges_warning
//= require spree/backend/returns/return_item_selection
//= require spree/backend/shipments
//= require spree/backend/states
//= require spree/backend/stock_location
//= require spree/backend/stock_management
//= require spree/backend/stock_movement
//= require spree/backend/stock_transfer
//= require spree/backend/taxon_autocomplete
//= require spree/backend/taxons
//= require spree/backend/users/edit
//= require spree/backend/user_picker
//= require spree/backend/variant_autocomplete
//= require spree/backend/variant_management
//= require spree/backend/zone

Spree.routes.edit_product = function (productId) {
  return Spree.adminPathFor('products/' + productId + '/edit')
}
Spree.routes.apply_coupon_code = function (orderId) {
  return Spree.pathFor('api/v2/platform/orders/' + orderId + '/apply_coupon_code')
}

// API v2
Spree.routes.countries_api_v2 = Spree.pathFor('api/v2/platform/countries')
Spree.routes.classifications_api_v2 = Spree.pathFor('api/v2/platform/classifications')
Spree.routes.line_items_api_v2 = Spree.pathFor('api/v2/platform/line_items')
Spree.routes.menus_api_v2 = Spree.pathFor('api/v2/platform/menus')
Spree.routes.menus_items_api_v2 = Spree.pathFor('api/v2/platform/menu_items')
Spree.routes.option_types_api_v2 = Spree.pathFor('api/v2/platform/option_types')
Spree.routes.option_values_api_v2 = Spree.pathFor('api/v2/platform/option_values')
Spree.routes.orders_api_v2 = Spree.pathFor('api/v2/platform/orders')
Spree.routes.pages_api_v2 = Spree.pathFor('api/v2/platform/cms_pages')
Spree.routes.payments_api_v2 = Spree.pathFor('/api/v2/platform/payments')
Spree.routes.products_api_v2 = Spree.pathFor('/api/v2/platform/products')
Spree.routes.sections_api_v2 = Spree.pathFor('/api/v2/platform/cms_sections')
Spree.routes.shipments_api_v2 = Spree.pathFor('/api/v2/platform/shipments')
Spree.routes.stock_items_api_v2 = Spree.pathFor('/api/v2/platform/stock_items')
Spree.routes.stock_locations_api_v2 = Spree.pathFor('/api/v2/platform/stock_locations')
Spree.routes.taxons_api_v2 = Spree.pathFor('/api/v2/platform/taxons')
Spree.routes.users_api_v2 = Spree.pathFor('api/v2/platform/users')
Spree.routes.variants_api_v2 = Spree.pathFor('api/v2/platform/variants')

Spree.apiV2Authentication = function() {
  if (typeof(OAUTH_TOKEN) !== 'undefined') {
    return {
      'Authorization': 'Bearer ' + OAUTH_TOKEN
    }
  }
}
