import "./controllers"
import "./bootstrap"
import flatpickr from "flatpickr"

import * as Turbo from "@hotwired/turbo"


class Dashboard {
  constructor() {
    const event = new Event("spree:load")

    document.addEventListener("turbo:load", function() { document.dispatchEvent(event) })
    document.addEventListener("turbo:render", function() { document.dispatchEvent(event) })
  }
}

export {
  Dashboard, Turbo, flatpickr
}
