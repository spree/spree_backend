/* eslint-disable no-undef */
document.addEventListener("spree:load", function() {
  const matches = document.querySelectorAll(".with-tip")

  matches.forEach(function(tip) {
    new bootstrap.Tooltip(tip)

    // ToDo Check this on touch devise
    if (("ontouchstart" in window)) {
      event.preventDefault()
    }
  })
})
