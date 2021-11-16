import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  eventsCheckboxes = document.getElementsByName("webhooks_subscriber[subscriptions][]")

  disableCheckboxes() {
    for (let cb of this.eventsCheckboxes) {
      cb.disabled = true
    }
  }

  enableCheckboxes() {
    for (let cb of this.eventsCheckboxes) {
      cb.disabled = false
    }
  }

  initialize() {
    let subscribe_to_all = document.getElementById("subscribe-to-all")
    if (subscribe_to_all.checked) {
      this.disableCheckboxes()
    }
  }
}
