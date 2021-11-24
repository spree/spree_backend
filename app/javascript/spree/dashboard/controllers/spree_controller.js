import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

    // This is a hack to allow legacy JavaScript to run in a Turbo enabled environment.
    // Once all JavaScript is reduced to Stimulus controllers, this can be removed.
    const event = new Event("spree:load")
    document.dispatchEvent(event)

    // The Issue
    // If you initiate common JavaScript with an event listener of "turbo:load"
    // This will work, but if someone submits an update to a field that is required,
    // a 442 Unprocessable entity is returned, and a render event is used render the errors in place.

    // Because this in not a successful "turbo:load" event, all common JavaScript will fail.
    // You could set up a separate listener for "turbo:render", but this can cause duplicate loading.
    // Using a Stimulus connect() is the correct way to go, but should be phased out as JavaScript is replaced
    // With Hotwire Frames and dedicated Stimulus controllers for the JavaScript you have remaining.

    // References:
    // https://github.com/hotwired/turbo-rails/issues/12#issuecomment-915893233
    // https://github.com/hotwired/turbo/issues/85#issuecomment-756259687
  }
}
