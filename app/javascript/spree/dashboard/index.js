/* eslint-disable no-unused-vars */

//////////////////////
//  Global Imports  //
//////////////////////
import * as Turbo from "@hotwired/turbo"
import * as RequestUtility from "./utilities/request_utility"
import { Application } from "@hotwired/stimulus"
import Flatpickr from "flatpickr"
import jQuery from "jquery"
import Bootstrap from "bootstrap"
import PopperJs from "popper.js"


//////////////////////
// Generic Scripts  //
//////////////////////
import "./utilities/bootstrap"


//////////////
// Stimulus //
//////////////
const application = Application.start()
application.debug = false

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


//////////////
// Exports  //
//////////////
window.Stimulus       = application
window.RequestUtility = RequestUtility
window.flatpickr      = Flatpickr
window.jQuery         = jQuery
window.bootstrap      = Bootstrap
