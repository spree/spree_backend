document.addEventListener("turbo:load", function() {
  $('[data-hook=stock_location_country] span#country .select2').on('change', function () { updateAddressState('') })
})
