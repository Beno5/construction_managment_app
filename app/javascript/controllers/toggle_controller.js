import { Controller } from "@hotwired/stimulus"

// Simple toggle controller for collapsible sections with sliding switch
export default class extends Controller {
  static targets = ["content", "switch"]

  toggle() {
    // Toggle content visibility based on switch state
    if (this.switchTarget.checked) {
      this.contentTarget.classList.remove("hidden")
    } else {
      this.contentTarget.classList.add("hidden")
    }
  }
}
