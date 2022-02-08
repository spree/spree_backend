import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove(event) {
    const tableRow = event.target.closest("tr")

    event.preventDefault()

    tableRow.classList.remove("animate__flashIn")
    tableRow.classList.add("animate__flashOut")
    tableRow.addEventListener("animationend", function() {
      tableRow.remove()
    })
  }
}
