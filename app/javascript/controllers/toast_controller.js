import { Controller } from "@hotwired/stimulus"

// Toast notification controller for programmatic toast messages
// Creates and displays toast notifications dynamically via JavaScript
//
// Usage:
//   Call showToast() from other controllers:
//
//   const toastEvent = new CustomEvent('toast:show', {
//     detail: {
//       message: 'Saved successfully',
//       type: 'success' // or 'error'
//     }
//   })
//   window.dispatchEvent(toastEvent)
//
// Types:
//   - success: Green toast with auto-dismiss (3000ms)
//   - error: Red toast with manual dismiss option
export default class extends Controller {
  connect() {
    // Ensure only one global listener is attached at a time to avoid duplicate toasts
    if (window.__toastListenerAttached) {
      this.isPrimaryListener = false
      return
    }

    this.isPrimaryListener = true
    this.boundShowToast = this.showToast.bind(this)
    window.__toastListenerAttached = true
    window.__toastListener = this.boundShowToast
    window.addEventListener('toast:show', this.boundShowToast)
  }

  disconnect() {
    // Only remove the global listener if this instance registered it
    if (this.isPrimaryListener) {
      window.removeEventListener('toast:show', this.boundShowToast)
      delete window.__toastListenerAttached
      delete window.__toastListener
    }
  }

  showToast(event) {
    const { message, type = 'success' } = event.detail

    // Determine styles based on type
    const styles = {
      success: {
        bg: 'bg-green-100',
        text: 'text-green-700',
        hoverText: 'hover:text-green-900',
        hoverBg: 'hover:bg-green-200',
        delay: 3000
      },
      error: {
        bg: 'bg-red-100',
        text: 'text-red-700',
        hoverText: 'hover:text-red-900',
        hoverBg: 'hover:bg-red-200',
        delay: 4000 // Auto-dismiss errors after a short time
      }
    }

    const style = styles[type] || styles.success

    // Create toast element
    const toast = document.createElement('div')
    toast.className = `${style.bg} ${style.text} rounded-lg text-base relative mb-2`
    toast.style.cssText = 'padding: 1rem 3rem 1rem 2rem; position: relative;'

    // Add auto-dismiss data attributes if needed
    if (style.delay > 0) {
      toast.setAttribute('data-controller', 'auto-dismiss')
      toast.setAttribute('data-auto-dismiss-delay-value', style.delay)
    }

    // Add message text
    const messageSpan = document.createElement('span')
    messageSpan.textContent = message
    toast.appendChild(messageSpan)

    // Add close button
    const closeButton = document.createElement('button')
    closeButton.type = 'button'
    closeButton.className = `cursor-pointer ${style.text} ${style.hoverText} ${style.hoverBg} rounded-full p-1 transition-colors`
    closeButton.style.cssText = 'position: absolute; top: 0.5rem; right: 0.5rem;'
    closeButton.setAttribute('aria-label', 'Close notification')

    if (style.delay > 0) {
      closeButton.setAttribute('data-action', 'click->auto-dismiss#dismiss')
    } else {
      closeButton.addEventListener('click', () => this.dismissToast(toast))
    }

    closeButton.innerHTML = `
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
      </svg>
    `
    toast.appendChild(closeButton)

    // Find the turbo-notifications container and append
    const container = document.getElementById('turbo-notifications') || document.getElementById('flash-messages')
    if (container) {
      container.appendChild(toast)

      // Manually trigger the auto-dismiss controller if it was added
      if (style.delay > 0) {
        const autoDismissController = this.application.getControllerForElementAndIdentifier(toast, 'auto-dismiss')
        if (autoDismissController) {
          autoDismissController.connect()
        }
      }
    }
  }

  dismissToast(toast) {
    // Apply fade-out transition
    toast.style.transition = "opacity 0.5s ease-out"
    toast.style.opacity = "0"

    // Remove element from DOM after fade-out completes
    setTimeout(() => {
      toast.remove()
    }, 500)
  }
}
