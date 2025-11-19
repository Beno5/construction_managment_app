import { Controller } from "@hotwired/stimulus"

// Manages AI import status polling and UI updates
export default class extends Controller {
  static targets = ["button", "notification", "spinner", "message"]
  static values = {
    statusUrl: String,
    cancelUrl: String,
    pollInterval: { type: Number, default: 3000 } // Poll every 3 seconds
  }

  connect() {
    this.checkStatus()
    this.startPolling()
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.pollTimer = setInterval(() => {
      this.checkStatus()
    }, this.pollIntervalValue)
  }

  stopPolling() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer)
      this.pollTimer = null
    }
  }

  async checkStatus() {
    try {
      const response = await fetch(this.statusUrlValue)
      const data = await response.json()

      if (data.in_progress) {
        this.showImportInProgress(data)
      } else {
        this.hideImportInProgress()
      }
    } catch (error) {
      console.error("Error checking import status:", error)
    }
  }

  showImportInProgress(data) {
    // Disable import button
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.buttonTarget.classList.add("opacity-50", "cursor-not-allowed")
    }

    // Show notification
    if (this.hasNotificationTarget) {
      this.notificationTarget.classList.remove("hidden")

      // Update message if available
      if (this.hasMessageTarget && data.filename) {
        // Update filename if present
        const filenameSpan = this.messageTarget.querySelector("[data-filename]")
        if (filenameSpan) {
          filenameSpan.textContent = data.filename
        }
      }
    }
  }

  hideImportInProgress() {
    // Enable import button
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = false
      this.buttonTarget.classList.remove("opacity-50", "cursor-not-allowed")
    }

    // Hide notification
    if (this.hasNotificationTarget) {
      this.notificationTarget.classList.add("hidden")
    }

    // Stop polling when import is complete
    this.stopPolling()
  }

  async cancelImport(event) {
    event.preventDefault()

    if (!confirm("Da li ste sigurni da želite zaustaviti AI import?")) {
      return
    }

    try {
      const statusUrl = new URL(this.statusUrlValue, window.location.origin)
      const cancelUrl = statusUrl.pathname.replace('/import_status', '/cancel_import')
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

      if (!csrfToken) {
        return
      }

      const response = await fetch(cancelUrl, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': csrfToken,
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      })

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const data = await response.json()

      if (data.success) {
        this.hideImportInProgress()
        // Success notification will be shown via Turbo Stream
      }
    } catch (error) {
      // Error notification will be shown via Turbo Stream
    }
  }
}
