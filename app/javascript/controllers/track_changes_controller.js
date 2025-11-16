import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="track-changes"
export default class extends Controller {
  static targets = ["input", "saveButton"]

  connect() {
    // Store original field values
    this.originalValues = this.inputTargets.map(el => this._valueOf(el))

    // Bind beforeunload handler to prevent accidental navigation with unsaved changes
    this.handleBeforeUnload = this.handleBeforeUnload.bind(this)
    window.addEventListener('beforeunload', this.handleBeforeUnload)
  }

  disconnect() {
    // Clean up event listener when controller is disconnected
    window.removeEventListener('beforeunload', this.handleBeforeUnload)
  }

  markChanged() {
    const changed = this.inputTargets.some((el, i) => this._valueOf(el) !== this.originalValues[i])

    if (changed) {
      this.saveButtonTarget.classList.remove("hidden")
    } else {
      this.saveButtonTarget.classList.add("hidden")
    }
  }

  reset() {
    // Reset original values after successful form submission
    this.originalValues = this.inputTargets.map(el => this._valueOf(el))
    this.saveButtonTarget.classList.add("hidden")
  }

  handleBeforeUnload(event) {
    // Check if there are unsaved changes (save button is visible)
    if (!this.saveButtonTarget.classList.contains("hidden")) {
      // Modern browsers ignore custom message, but still show confirmation dialog
      event.preventDefault()
      event.returnValue = '' // Required for Chrome
      return '' // Required for some older browsers
    }
  }

  _valueOf(el) {
    if (el.type === "checkbox" || el.type === "radio") {
      return el.checked
    } else {
      return el.value
    }
  }
}
