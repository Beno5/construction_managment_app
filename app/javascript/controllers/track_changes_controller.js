import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="track-changes"
export default class extends Controller {
  static targets = ["input", "saveButton"]

  connect() {
    this.skipNavigationGuard = false

    // Store original field values (may be empty if used only for navigation guard)
    this.originalValues = this.inputTargets.map(el => this._valueOf(el))

    // Bind beforeunload handler to prevent accidental navigation with unsaved changes
    this.handleBeforeUnload = this.handleBeforeUnload.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    window.addEventListener('beforeunload', this.handleBeforeUnload)
    this.element.addEventListener('submit', this.handleSubmit)
  }

  disconnect() {
    // Clean up event listener when controller is disconnected
    window.removeEventListener('beforeunload', this.handleBeforeUnload)
    this.element.removeEventListener('submit', this.handleSubmit)
  }

  markChanged() {
    const changed = this.isDirty()
    this.toggleSaveButton(changed)
  }

  reset() {
    // Reset original values after successful form submission
    this.originalValues = this.inputTargets.map(el => this._valueOf(el))
    this.toggleSaveButton(false)
  }

  confirmNavigation(event) {
    if (this.skipNavigationGuard) return
    if (this.isDirty()) {
      const message = 'You have unsaved changes. Leave without saving?'
      if (!window.confirm(message)) {
        event.preventDefault()
        event.stopPropagation()
      }
    }
  }

  handleBeforeUnload(event) {
    if (this.skipNavigationGuard) return
    // Check if there are unsaved changes (save button is visible)
    if (this.isDirty()) {
      // Modern browsers ignore custom message, but still show confirmation dialog
      event.preventDefault()
      event.returnValue = '' // Required for Chrome
      return '' // Required for some older browsers
    }
  }

  handleSubmit(event) {
    this.skipNavigationGuard = true
    window.removeEventListener('beforeunload', this.handleBeforeUnload)

    // If submission gets cancelled (client-side validation), re-enable guard on next tick
    setTimeout(() => {
      if (event.defaultPrevented) {
        this.skipNavigationGuard = false
        window.addEventListener('beforeunload', this.handleBeforeUnload)
      }
    }, 0)
  }

  skipNavigationPrompt() {
    this.skipNavigationGuard = true
    window.removeEventListener('beforeunload', this.handleBeforeUnload)
  }

  isDirty() {
    const inputsDirty = this.inputTargets.some((el, i) => this._valueOf(el) !== this.originalValues[i])
    const inlineEditing = !!document.querySelector('[data-inline-edit-active="true"]') || !!window.__inlineEditActiveElement
    return inputsDirty || inlineEditing
  }

  toggleSaveButton(show) {
    if (!this.hasSaveButtonTarget) return
    this.saveButtonTarget.classList.toggle("hidden", !show)
  }

  _valueOf(el) {
    if (el.type === "checkbox" || el.type === "radio") {
      return el.checked
    } else {
      return el.value
    }
  }
}
