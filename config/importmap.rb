pin "application-spree-backend", to: "spree/backend/application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/request.js", to: "requestjs.js", preload: true
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.2/modular/sortable.esm.js"

pin_all_from Spree::Backend::Engine.root.join("app/javascript/spree/backend/controllers"), under: "controllers", to: "spree/backend/controllers"
pin_all_from Spree::Backend::Engine.root.join("app/javascript/spree/backend/helpers"), under: "helpers", to: "spree/backend/helpers"
