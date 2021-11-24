document.addEventListener("spree:load", function() {
  $(document).ajaxStart(function () {
    Turbo.navigator.delegate.adapter.progressBar.setValue(0)
    Turbo.navigator.delegate.adapter.progressBar.show()
  })
  $(document).ajaxStop(function () {
    Turbo.navigator.delegate.adapter.progressBar.setValue(1)
    Turbo.navigator.delegate.adapter.progressBar.hide()
  })
})
