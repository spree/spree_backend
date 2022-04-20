/* eslint-disable no-undef */

import "bootstrap"
import "popper.js"

document.addEventListener("spree:load", function() {
  $(".with-tip").each(function() {
    $(this).tooltip()
  })

  $(".with-tip").on("show.bs.tooltip", function(event) {
    if (("ontouchstart" in window)) {
      event.preventDefault()
    }
  })
})
