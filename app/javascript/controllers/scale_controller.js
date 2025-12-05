import { Controller } from "@hotwired/stimulus"

// Optional: Toggle between normal (100%) and scaled (80%) UI
// Usage: Add toggle button with data-controller="scale" and data-action="click->scale#toggle"
export default class extends Controller {
  connect() {
    // Check localStorage for user preference on page load
    const userId = this.element.dataset.userId
    if (!userId) return

    const savedState = localStorage.getItem(`scale_enabled_${userId}`)

    // If user previously disabled scaling, apply it immediately
    if (savedState === 'false') {
      this.disable()
    }
  }

  toggle() {
    const wrapper = document.getElementById('app-scale-wrapper')
    if (!wrapper) return

    const isDisabled = wrapper.classList.contains('scale-disabled')

    if (isDisabled) {
      this.enable()
    } else {
      this.disable()
    }
  }

  enable() {
    const wrapper = document.getElementById('app-scale-wrapper')
    wrapper.classList.remove('scale-disabled')

    // Save preference to localStorage
    const userId = this.element.dataset.userId
    if (userId) {
      localStorage.setItem(`scale_enabled_${userId}`, 'true')
    }

    // Optional: Show toast notification
    this.showNotification('UI scaled to 80%')
  }

  disable() {
    const wrapper = document.getElementById('app-scale-wrapper')
    wrapper.classList.add('scale-disabled')

    // Save preference to localStorage
    const userId = this.element.dataset.userId
    if (userId) {
      localStorage.setItem(`scale_enabled_${userId}`, 'false')
    }

    // Optional: Show toast notification
    this.showNotification('UI scale disabled (100%)')
  }

  showNotification(message) {
    // Dispatch custom event for toast controller to handle
    const event = new CustomEvent('toast:show', {
      detail: { message, type: 'info' }
    })
    window.dispatchEvent(event)
  }
}
