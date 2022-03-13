import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    kind: String,
    content: String
  }

  connect () {
    show_flash(this.kindValue, this.contentValue)
  }
}
