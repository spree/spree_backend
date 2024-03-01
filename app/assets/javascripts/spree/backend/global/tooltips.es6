const initTooltips = () => {
  $('.with-tip').each(function() {
    $(this).tooltip()
  })

  $('.with-tip').on('show.bs.tooltip', function(event) {
    if (('ontouchstart' in window)) {
      event.preventDefault()
    }
  })
}

const removeTooltips = () => {
  $('.with-tip').each(function() {
    $(this).tooltip('dispose')
  })
}

document.addEventListener("turbo:click", removeTooltips)
document.addEventListener("turbo:load", initTooltips)
document.addEventListener('turbo:frame-render', initTooltips)