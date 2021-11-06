pin_all_from File.expand_path('../app/assets/javascripts/spree/dashboard', __dir__), to: 'spree/dashboard'
pin 'spree-dashboard', preload: true

pin '@hotwired/stimulus', to: 'stimulus.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from File.expand_path('../app/assets/javascripts/spree/dashboard/controllers', __dir__), to: 'controllers'

pin "@hotwired/turbo-rails", to: "turbo.js", preload: true
