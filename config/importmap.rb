pin "@hotwired/stimulus", to: "stimulus.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin 'spree-dashboard', preload: true

pin_all_from File.expand_path('../app/assets/javascripts/spree/dashboard', __dir__), to: 'spree/dashboard'
pin_all_from File.expand_path('../app/assets/javascripts/spree/dashboard/controllers', __dir__), under: "controllers"
