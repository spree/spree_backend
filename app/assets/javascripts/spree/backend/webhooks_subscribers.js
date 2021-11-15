$(document).ready(function () {
  'use strict'

  checkCorrectCheckboxes();

  $('.events').on('change', function () {
    checkCorrectCheckboxes();
  })
})

function checkCorrectCheckboxes() {
  $('.events-checkbox').prop('disabled', $('#subscribe-to-all').prop('checked'));
}
