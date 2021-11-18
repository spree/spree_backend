import jquery from 'jquery'
import 'bootstrap'
import 'popper.js'

const $ = jquery

document.addEventListener("turbo:render", function() {
  $('.with-tip').each(function() {
    $(this).tooltip({
      container: $(this)
    })
  })

  $('.with-tip').on('show.bs.tooltip', function(event) {
    if (('ontouchstart' in window)) {
      event.preventDefault()
    }
  })
})
