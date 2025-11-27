import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "display"]
  static values = {
    url: String,
    documentId: String,
    recordUpdatedAt: String
  }

  connect() {
    // Create hidden file input if it doesn't exist
    if (!this.hasInputTarget) {
      const input = document.createElement('input')
      input.type = 'file'
      input.style.display = 'none'
      input.dataset.fileUploadTarget = 'input'
      input.addEventListener('change', this.upload.bind(this))
      this.element.appendChild(input)
    }
  }

  activate(event) {
    event.preventDefault()
    event.stopPropagation()

    // Trigger file picker
    this.inputTarget.click()
  }

  async upload(event) {
    const file = event.target.files[0]
    if (!file) return

    // Show loading state
    const originalContent = this.displayTarget.innerHTML
    this.displayTarget.innerHTML = '<span class="text-gray-500">Uploading...</span>'
    this.element.classList.add('opacity-50', 'pointer-events-none')

    try {
      // Create FormData
      const formData = new FormData()
      formData.append('document[file]', file)
      formData.append('record_updated_at', this.recordUpdatedAtValue)

      // Send PATCH request
      const response = await fetch(this.urlValue, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: formData
      })

      const data = await response.json()

      if (response.ok && data.success) {
        // Update display with new filename and upload icon
        const filename = file.name
        this.displayTarget.innerHTML = `
          <span class="flex items-center gap-3">
            <svg class="w-6 h-6 text-blue-600 dark:text-blue-400 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
              <path d="M5.5 13a3.5 3.5 0 01-.369-6.98 4 4 0 117.753-1.977A4.5 4.5 0 1113.5 13H11V9.413l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13H5.5z"/>
            </svg>
            <span class="truncate max-w-[250px] font-medium">${filename}</span>
          </span>
        `

        // Update timestamp for next edit
        if (data.data && data.data.updated_at) {
          this.recordUpdatedAtValue = data.data.updated_at
          this.updateAllFieldsTimestamp(data.data.updated_at)
        }

        // Show success toast
        this.showToast('success', 'File uploaded successfully')

        // Flash green border
        this.element.classList.add('border-2', 'border-green-500')
        setTimeout(() => {
          this.element.classList.remove('border-2', 'border-green-500')
        }, 2000)
      } else if (response.status === 409 && data.conflict) {
        // Conflict - another user modified the record
        alert(data.error || 'This record was modified by another user. Please refresh the page.')
        this.displayTarget.innerHTML = originalContent
      } else {
        // Validation or other errors
        const errorMsg = data.errors ? data.errors.join(', ') : 'Failed to upload file'
        this.showToast('error', errorMsg)
        this.displayTarget.innerHTML = originalContent
      }
    } catch (error) {
      console.error('File upload error:', error)
      this.showToast('error', 'Network error. Please try again.')
      this.displayTarget.innerHTML = originalContent
    } finally {
      // Remove loading state
      this.element.classList.remove('opacity-50', 'pointer-events-none')

      // Clear file input so same file can be uploaded again
      this.inputTarget.value = ''
    }
  }

  updateAllFieldsTimestamp(newTimestamp) {
    // Find all inline-edit and file-upload elements with the same URL (same record)
    const allFields = document.querySelectorAll(`[data-inline-edit-url-value="${this.urlValue}"], [data-file-upload-url-value="${this.urlValue}"]`)

    allFields.forEach(field => {
      // Update inline-edit timestamps
      if (field.dataset.inlineEditRecordUpdatedAtValue) {
        field.dataset.inlineEditRecordUpdatedAtValue = newTimestamp
      }
      // Update file-upload timestamps
      if (field.dataset.fileUploadRecordUpdatedAtValue) {
        field.dataset.fileUploadRecordUpdatedAtValue = newTimestamp
      }
    })
  }

  showToast(type, message) {
    // Find or create toast controller element
    const toastController = document.querySelector('[data-controller~="toast"]')
    if (toastController) {
      const event = new CustomEvent('show-toast', {
        detail: { type, message },
        bubbles: true
      })
      toastController.dispatchEvent(event)
    }
  }
}
