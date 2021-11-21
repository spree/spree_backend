import "./controllers"
import "./utilities/bootstrap"

import flatpickr from "flatpickr"
import * as Turbo from "@hotwired/turbo"

class Dashboard {
  constructor() {
    console.log("Spree Dashboard Initiated")
  }
}

export { Dashboard, flatpickr, Turbo }
