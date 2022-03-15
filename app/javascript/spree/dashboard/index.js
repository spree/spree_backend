/* eslint-disable no-undef */

//////////////////////////
// Initialize Dashboard //
//////////////////////////
class Dashboard {
  constructor() { console.log("Spree Dashboard Initialized") }
}


////////////
// Import //
////////////
import * as RequestUtility from "./utilities/request_utility"
import { Application } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import jQuery from "jquery"
import * as Bootstrap from "bootstrap"


////////////////////
// Bind To Window //
////////////////////
if (!window.jQuery)     { window.$ = window.jQuery = jQuery }
if (!window.bootstrap)  { window.bootstrap = Bootstrap }


///////////////
// Utilities //
///////////////
import "./utilities/bootstrap"


//////////////
// Stimulus //
//////////////
const application = Application.start()
application.debug = false
window.Stimulus = application

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


////////////
// Export //
////////////
export { Dashboard, application, flatpickr, RequestUtility }
