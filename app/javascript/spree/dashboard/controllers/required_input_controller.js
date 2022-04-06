// Adds the required html attribute to a target input
// if another specified input has content.
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "togglableInput"]

  toggleRequired(event) {
    if (event.target.value === "") {
      this.togglableInputTarget.required = false
    } else {
      this.togglableInputTarget.required = true
    }
  }
}
