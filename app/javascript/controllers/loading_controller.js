import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    // Track number of active requests to handle multiple simultaneous requests
    this.activeRequests = 0
    // Track timeout for delayed loading display
    this.loadingTimeout = null
    // Delay before showing loading overlay (in milliseconds)
    this.loadingDelay = 300

    // Bind event listeners
    this.boundShowLoading = this.showLoading.bind(this)
    this.boundHideLoading = this.hideLoading.bind(this)
    this.boundHandleError = this.handleError.bind(this)

    // Listen to Turbo events on document level
    document.addEventListener("turbo:submit-start", this.boundShowLoading)
    document.addEventListener("turbo:before-fetch-request", this.boundShowLoading)
    document.addEventListener("turbo:submit-end", this.boundHideLoading)
    document.addEventListener("turbo:before-fetch-response", this.boundHideLoading)
    document.addEventListener("turbo:fetch-request-error", this.boundHandleError)

    // Additional Turbo events for better coverage
    document.addEventListener("turbo:before-visit", this.boundShowLoading)
    document.addEventListener("turbo:visit", this.boundHideLoading)
    document.addEventListener("turbo:before-render", this.boundHideLoading)

    console.log("🔄 Loading controller connected")
  }

  disconnect() {
    // Clear any pending timeout
    if (this.loadingTimeout) {
      clearTimeout(this.loadingTimeout)
      this.loadingTimeout = null
    }

    // Clean up event listeners when controller is disconnected
    document.removeEventListener("turbo:submit-start", this.boundShowLoading)
    document.removeEventListener("turbo:before-fetch-request", this.boundShowLoading)
    document.removeEventListener("turbo:submit-end", this.boundHideLoading)
    document.removeEventListener("turbo:before-fetch-response", this.boundHideLoading)
    document.removeEventListener("turbo:fetch-request-error", this.boundHandleError)
    document.removeEventListener("turbo:before-visit", this.boundShowLoading)
    document.removeEventListener("turbo:visit", this.boundHideLoading)
    document.removeEventListener("turbo:before-render", this.boundHideLoading)

    console.log("🔄 Loading controller disconnected")
  }

  showLoading(event) {
    // Increment request counter
    this.activeRequests++

    console.log(`🟢 Loading started (${this.activeRequests} active requests)`, event.type)

    // Clear any existing timeout
    if (this.loadingTimeout) {
      clearTimeout(this.loadingTimeout)
    }

    // Only show overlay after delay (if request is still active)
    this.loadingTimeout = setTimeout(() => {
      // Only show if there are still active requests
      if (this.activeRequests > 0 && this.hasOverlayTarget && this.overlayTarget.classList.contains("hidden")) {
        this.overlayTarget.classList.remove("hidden")

        // Add fade-in animation
        requestAnimationFrame(() => {
          this.overlayTarget.classList.remove("opacity-0")
          this.overlayTarget.classList.add("opacity-100")
        })
      }
    }, this.loadingDelay)
  }

  hideLoading(event) {
    // Decrement request counter
    this.activeRequests = Math.max(0, this.activeRequests - 1)

    console.log(`🔴 Loading ended (${this.activeRequests} active requests)`, event.type)

    // Clear the timeout if request finished before delay
    if (this.activeRequests === 0 && this.loadingTimeout) {
      clearTimeout(this.loadingTimeout)
      this.loadingTimeout = null
    }

    // Only hide overlay when all requests are complete
    if (this.activeRequests === 0 && this.hasOverlayTarget) {
      // Add fade-out animation
      this.overlayTarget.classList.remove("opacity-100")
      this.overlayTarget.classList.add("opacity-0")

      // Hide after animation completes
      setTimeout(() => {
        if (this.activeRequests === 0) {
          this.overlayTarget.classList.add("hidden")
        }
      }, 200) // Match transition duration
    }
  }

  handleError(event) {
    console.error("❌ Request error detected", event)

    // Clear any pending timeout
    if (this.loadingTimeout) {
      clearTimeout(this.loadingTimeout)
      this.loadingTimeout = null
    }

    // Force hide loading on error
    this.activeRequests = 0

    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-100")
      this.overlayTarget.classList.add("opacity-0", "hidden")
    }
  }

  // Manual methods for programmatic control
  forceShow() {
    this.activeRequests++
    this.showLoading({ type: "manual" })
  }

  forceHide() {
    this.activeRequests = 0
    this.hideLoading({ type: "manual" })
  }
}
