document.addEventListener("spree:load", function() {
  flatpickr.setDefaults({
    altInput: true,
    time_24hr: true,
    altInputClass: 'flatpickr-alt-input',
    locale: Spree.translations.flatpickr_locale
  })

  var dateFrom = flatpickr('.datePickerFrom', {
    onChange: function(selectedDates) {
      dateTo.set('minDate', selectedDates[0])
    }
  })

  var dateTo = flatpickr('.datePickerTo', {
    onChange: function(selectedDates) {
      dateFrom.set('maxDate', selectedDates[0])
    }
  })

  flatpickr('.datepicker', {})
})

document.addEventListener("turbo:before-cache", function() {
  document.querySelectorAll('.datePickerFrom, .datePickerTo, .datepicker').forEach(function(element) {
    if (element._flatpickr) {
      element._flatpickr.destroy()
    }
  })
})

