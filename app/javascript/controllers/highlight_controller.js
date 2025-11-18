import { Controller } from "@hotwired/stimulus"

// Highlight controller for temporarily highlighting newly created elements
// Adds a blue border animation that fades after a configurable duration
//
// Usage:
//   <div data-controller="highlight" data-highlight-duration-value="5000">
//     Your content
//   </div>
//
// Values:
//   - duration: milliseconds to show highlight (default: 5000)
export default class extends Controller {
  static values = {
    duration: { type: Number, default: 5000 } // Default 5 seconds
  }

  connect() {
    // Save original border classes
    this.originalBorderClass = 'border-gray-200'
    this.originalBorderWidth = this.element.classList.contains('border-4') ? 'border-4' : 'border'

    // Add highlight border immediately
    this.element.classList.remove('border-gray-200', 'border')
    this.element.classList.add('border-primary-600', 'border-4')
    this.element.style.transition = "border-color 1s ease-out, border-width 0.5s ease-out"

    // Schedule removal of highlight after configured duration
    this.timeoutId = setTimeout(() => {
      this.removeHighlight()
    }, this.durationValue)
  }

  disconnect() {
    // Clean up timeout if controller is disconnected before auto-dismiss
    this.clearTimeout()
  }

  // Remove highlight action
  removeHighlight() {
    this.clearTimeout()

    // Fade out border by transitioning to original color
    this.element.classList.remove('border-primary-600', 'border-4')
    this.element.classList.add(this.originalBorderClass, this.originalBorderWidth)
  }

  // Helper to clear timeout and prevent memory leaks
  clearTimeout() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
      this.timeoutId = null
    }
  }
}
