import { Controller } from "@hotwired/stimulus"

// Simple toggle controller for collapsible sections with sliding switch
export default class extends Controller {
  static targets = ["switch"]

  connect() {
    // State is already applied by inline script, just ensure visibility
    // If for some reason inline script didn't run, ensure toggle-init is added
    if (!this.element.classList.contains("toggle-init")) {
      this.element.classList.add("toggle-init")
    }

    // Sync checkbox state with current collapsed state
    const isCollapsed = this.element.classList.contains("toggle-collapsed")
    if (this.hasSwitchTarget) {
      this.switchTarget.checked = !isCollapsed
    }
  }

  toggle() {
    // Toggle CSS class based on switch state
    if (this.switchTarget.checked) {
      this.element.classList.remove("toggle-collapsed")
    } else {
      this.element.classList.add("toggle-collapsed")
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
