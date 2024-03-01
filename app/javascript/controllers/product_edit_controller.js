import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["availableOn", "makeActiveAt", "discontinueOn", "status"]

  initialize() {
    $(this.statusTarget).on("select2:select", function (e) {
      let event = new Event("change")
      e.target.dispatchEvent(event)
    })
  }

  connect() {
    this.statusTarget.dispatchEvent(new Event("change"))
  }

  switchAvailabilityDatesFields(event) {
    let status = event.target.value
    if (status === "draft") {
      this.show(this.availableOnTarget)
      this.show(this.makeActiveAtTarget)
    } else if (status === "active") {
      this.show(this.availableOnTarget)
      this.hide(this.makeActiveAtTarget)
    } else {
      this.hide(this.availableOnTarget)
      this.hide(this.makeActiveAtTarget)
    }
  }

  show(element) {
    element.style.display = "block"
  }

  hide(element) {
    element.style.display = "none"
  }
}
