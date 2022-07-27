import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ["source"]
  }

  copy(event) {
    console.log(event)
    event.preventDefault()
    this.sourceTarget.select()
    document.execCommand("copy")
  }
}
