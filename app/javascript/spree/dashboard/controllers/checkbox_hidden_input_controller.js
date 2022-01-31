import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  toggleHiddenInputValue (event) {
    if (event.target.checked) {
      this.inputTarget.value = 1
    } else {
      this.inputTarget.value = 0
    }
  }
}
