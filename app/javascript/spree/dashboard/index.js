import "./controllers"
import "./bootstrap"
import flatpickr from "flatpickr"

import * as Turbo from "@hotwired/turbo"


class Dashboard {
  constructor() {
    const event = new Event("spree:load")

    document.addEventListener("turbo:load", function() { document.dispatchEvent(event) })

    // If a form is submitted with an invalid field, the response for Hotwire should be a
    // 422 Unprocessable Entity with a render, but this causes all JavaScript initialized from "turbo:load" to
    // fail.

    // document.addEventListener("turbo:render", function() { document.dispatchEvent(event) })
  }
}

export {
  Dashboard, Turbo, flatpickr
}
