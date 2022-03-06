/* eslint-disable no-undef */

////////////////////
// Global Imports //
////////////////////
import * as RequestUtility from "./utilities/request_utility"
import { Application } from "@hotwired/stimulus"
import Flatpickr from "flatpickr"
import jQuery from "jquery"
import Bootstrap from "bootstrap"


///////////////////////
// Exports To Window //
///////////////////////
if (!window.Turbo)          { require("@hotwired/turbo-rails") }
if (!window.Stimulus)       { window.Stimulus = Application.start() }
if (!window.RequestUtility) { window.RequestUtility = RequestUtility }
if (!window.flatpickr)      { window.flatpickr = Flatpickr }
if (!window.jQuery)         { window.$ = window.jQuery = jQuery }
if (!window.bootstrap)      { window.bootstrap = Bootstrap }

/////////////////////
// Generic Scripts //
/////////////////////
import "./utilities/bootstrap"


//////////////
// Stimulus //
//////////////
import UploadButtonController from "./controllers/upload_button_controller"
Stimulus.register("upload-button", UploadButtonController)

import SpreeController from "./controllers/spree_controller"
Stimulus.register("spree", SpreeController)

import SortableTreeController from "./controllers/sortable_tree_controller"
Stimulus.register("sortable-tree", SortableTreeController)

import WebhooksSubscriberEventsController from "./controllers/webhooks_subscriber_events_controller"
Stimulus.register("webhooks-subscriber-events", WebhooksSubscriberEventsController)

import PasswordToggleController from "./controllers/password_toggle_controller"
Stimulus.register("password-toggle", PasswordToggleController)

import ClipboardController from "./controllers/clipboard_controller"
Stimulus.register("clipboard", ClipboardController)

import ProductEditController from "./controllers/product_edit_controller"
Stimulus.register("product-edit", ProductEditController)
