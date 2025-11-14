import { Controller } from "@hotwired/stimulus"

// Auto-dismiss controller for notifications and flash messages
// Automatically fades out and removes elements after a configurable delay
//
// Usage:
//   <div data-controller="auto-dismiss" data-auto-dismiss-delay-value="5000">
//     Your notification content
//   </div>
//
// Values:
//   - delay: milliseconds before auto-dismiss (default: 5000)
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 } // Default 5 seconds
  }

  connect() {
    // Schedule auto-dismiss after configured delay
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }

  disconnect() {
    // Clean up timeout if controller is disconnected before auto-dismiss
    this.clearTimeout()
  }

  // Dismiss action - can be triggered manually via data-action
  dismiss() {
    this.clearTimeout()

    // Apply fade-out transition
    this.element.style.transition = "opacity 0.5s ease-out"
    this.element.style.opacity = "0"

    // Remove element from DOM after fade-out completes
    setTimeout(() => {
      this.element.remove()
    }, 500) // Match transition duration
  }

  // Helper to clear timeout and prevent memory leaks
  clearTimeout() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
      this.timeoutId = null
    }
  }
}
