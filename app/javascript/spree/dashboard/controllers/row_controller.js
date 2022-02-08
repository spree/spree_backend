import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove(event) {
    event.preventDefault()
    event.target.closest("tr").remove()
  }
}
