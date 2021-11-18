import "./controllers"
import "./bootstrap"
import flatpickr from "flatpickr"

import * as Turbo from "@hotwired/turbo"


class Dashboard {
  constructor() {
    console.log("Spree Dashboard initialized")
  }
}

export {
  Dashboard, Turbo, flatpickr
}
