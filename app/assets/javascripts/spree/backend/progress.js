document.addEventListener("turbo:load", function() {
  $(document).ajaxStart(function () {
    $('#progress').stop(true, true).fadeIn()
  })
  $(document).ajaxStop(function () {
    $('#progress').fadeOut()
  })
})
