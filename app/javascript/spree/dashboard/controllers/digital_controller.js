import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "uploadButton"]

  initialize() {
    this.uploadButtonTarget.disabled = true
  }

  buttonState() {
    this.uploadButtonTarget.disabled = false
  }
}
