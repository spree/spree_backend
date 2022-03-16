/* eslint-disable no-undef */

/////////////////////////
// Node Module Imports //
/////////////////////////
import "@hotwired/turbo-rails"
import * as RequestUtility from "./utilities/request_utility"
import { Application } from "@hotwired/stimulus"
import Flatpickr from "flatpickr"
import jQuery from "jquery"
import Bootstrap from "bootstrap"


////////////////////
// Custom Imports //
////////////////////
import "./utilities/bootstrap"
import UploadButtonController from "./controllers/upload_button_controller"
import SpreeController from "./controllers/spree_controller"
import SortableTreeController from "./controllers/sortable_tree_controller"
import WebhooksSubscriberEventsController from "./controllers/webhooks_subscriber_events_controller"
import PasswordToggleController from "./controllers/password_toggle_controller"
import ClipboardController from "./controllers/clipboard_controller"
import ProductEditController from "./controllers/product_edit_controller"


///////////////////////
// Exports To Window //
///////////////////////
if (!window.Stimulus)       { window.Stimulus = Application.start() }
if (!window.RequestUtility) { window.RequestUtility = RequestUtility }
if (!window.flatpickr)      { window.flatpickr = Flatpickr }
if (!window.jQuery)         { window.$ = window.jQuery = jQuery }
if (!window.bootstrap)      { window.bootstrap = Bootstrap }


///////////////////////
// Stimulus Register //
///////////////////////
Stimulus.register("upload-button", UploadButtonController)
Stimulus.register("spree", SpreeController)
Stimulus.register("sortable-tree", SortableTreeController)
Stimulus.register("webhooks-subscriber-events", WebhooksSubscriberEventsController)
Stimulus.register("password-toggle", PasswordToggleController)
Stimulus.register("clipboard", ClipboardController)
Stimulus.register("product-edit", ProductEditController)
