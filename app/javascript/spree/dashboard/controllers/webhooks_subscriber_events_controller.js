import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "eventsCheckbox", "subscribeToAll" ]

  disableCheckboxes() {
    for (let cb of this.eventsCheckboxTargets) {
      cb.disabled = true
    }
  }

  enableCheckboxes() {
    for (let cb of this.eventsCheckboxTargets) {
      cb.disabled = false
    }
  }

  initialize() {
    if (this.subscribeToAllTarget.checked) {
      this.disableCheckboxes()
    }
  }
}
