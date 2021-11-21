//
// Initialize Dashboard
class Dashboard {
  constructor() {
    console.log("Spree Dashboard Initialized")
  }
}

//
// Import JavaScript packages that are required globally.
import { Application } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import * as Turbo from "@hotwired/turbo"

//
// Import Utility JavaScript required globally.
import "./utilities/bootstrap"

//
// Stimulus - Setup
const application = Application.start()
application.debug = false
window.Stimulus = application

// Stimulus - Controllers
import UploadButtonController from "./controllers/upload_button_controller"
application.register("upload-button", UploadButtonController)

import SpreeController from "./controllers/spree_controller"
application.register("spree", SpreeController)

import SortableTreeController from "./controllers/sortable_tree_controller"
application.register("sortable-tree", SortableTreeController)

//
// Export
export { Dashboard, application, flatpickr, Turbo }
