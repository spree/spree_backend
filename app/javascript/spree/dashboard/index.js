//
// Initialize Dashboard
class Dashboard {
  constructor() {
    console.log("Spree Dashboard Initialized")
  }
}

if (!window.Turbo) {
  console.warn("Please import '@hotwired/turbo-rails' before '@spree/dashboard' to use Rails Turbo within the Spree Dashboard environment.")
}

//
// Import JavaScript packages that are required globally.
import { Application } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

//
// Import Utility JavaScript required globally.
import "./utilities/bootstrap"

//
// Stimulus - Setup
const application = Application.start()
application.debug = false
window.Stimulus = application

// Stimulus - Spree Controllers
import UploadButtonController from "./controllers/upload_button_controller"
application.register("upload-button", UploadButtonController)

import SpreeController from "./controllers/spree_controller"
application.register("spree", SpreeController)

import SortableTreeController from "./controllers/sortable_tree_controller"
application.register("sortable-tree", SortableTreeController)

import WebhooksSubscriberEventsController from "./controllers/webhooks_subscriber_events_controller"
application.register("webhooks_subscriber_events", WebhooksSubscriberEventsController)

import PasswordToggleController from "./controllers/password_toggle_controller"
application.register("password-toggle", PasswordToggleController)

import ClipboardController from "./controllers/clipboard_controller"
application.register("clipboard", ClipboardController)

import ProductEditController from "./controllers/product_edit_controller"
application.register("product-edit", ProductEditController)

import * as RequestUtility from "./utilities/request_utility"

//
// Export
export { Dashboard, application, flatpickr, RequestUtility }
