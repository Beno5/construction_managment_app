import { Controller } from "@hotwired/stimulus"

// Simple toggle controller for collapsible sections with sliding switch
export default class extends Controller {
  static targets = ["content", "switch"]

  connect() {
    // Restore toggle state from localStorage on page load
    const sectionId = this.element.dataset.sectionId
    const userId = this.element.dataset.userId

    if (sectionId && userId) {
      const storageKey = `toggle_${userId}_${sectionId}`
      const savedState = localStorage.getItem(storageKey)

      if (savedState !== null) {
        const isChecked = savedState === "true"
        this.switchTarget.checked = isChecked

        // Apply the saved state to content visibility
        if (isChecked) {
          this.contentTarget.classList.remove("hidden")
        } else {
          this.contentTarget.classList.add("hidden")
        }
      }
    }
  }

  toggle() {
    // Toggle content visibility based on switch state
    if (this.switchTarget.checked) {
      this.contentTarget.classList.remove("hidden")
    } else {
      this.contentTarget.classList.add("hidden")
    }

    // Save toggle state to localStorage
    const sectionId = this.element.dataset.sectionId
    const userId = this.element.dataset.userId

    if (sectionId && userId) {
      const storageKey = `toggle_${userId}_${sectionId}`
      localStorage.setItem(storageKey, this.switchTarget.checked)
    }
  }
}
