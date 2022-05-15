import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ["uploadButton"]
  }

  initialize() {
    this.uploadButtonTarget.disabled = true
  }

  buttonState() {
    this.uploadButtonTarget.disabled = false
  }
}
