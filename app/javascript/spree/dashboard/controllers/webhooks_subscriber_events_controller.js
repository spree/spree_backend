import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ["eventsCheckboxesContainer", "subscribeToAll"]
  }

  hideCheckboxes() {
    this.eventsCheckboxesContainerTarget.hidden = true
  }

  showCheckboxes() {
    this.eventsCheckboxesContainerTarget.hidden = false
  }

  initialize() {
    if (this.subscribeToAllTarget.checked) {
      this.hideCheckboxes()
    }
  }
}
