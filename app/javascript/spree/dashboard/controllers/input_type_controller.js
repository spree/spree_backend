import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input"]

  update (event) {
    this.inputTarget.value = ''
    this.inputTarget.type = event.target.value
  }

}
