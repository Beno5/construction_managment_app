import { Controller } from "@hotwired/stimulus"

// Generic inline edit controller for any model
// Supports double-click activation, multiple field types, validation, and optimistic locking
//
// Usage:
//   <div data-controller="inline-edit"
//        data-inline-edit-model-value="worker"
//        data-inline-edit-field-value="first_name"
//        data-inline-edit-type-value="text"
//        data-inline-edit-url-value="/businesses/1/workers/123"
//        data-inline-edit-original-value="<%= worker.first_name %>"
//        data-inline-edit-record-updated-at-value="<%= worker.updated_at.iso8601 %>"
//        data-action="dblclick->inline-edit#activate">
//     <%= worker.first_name %>
//   </div>
//
// For select fields, add options:
//   data-inline-edit-options-value='{"hourly":"Hourly","daily":"Daily"}'
//
// Values:
//   - model: Model name (e.g., "worker", "task")
//   - field: Field name (e.g., "first_name", "price_per_unit")
//   - type: Field type (text, number, date, select, email, textarea)
//   - url: PATCH endpoint URL
//   - original: Original value for cancel/revert
//   - recordUpdatedAt: Record's updated_at timestamp (for optimistic locking)
//   - options: For select fields, object with key-value pairs
//   - required: Boolean, whether field is required (default: false)
export default class extends Controller {
  static values = {
    model: String,
    field: String,
    type: { type: String, default: 'text' },
    url: String,
    original: String,
    recordUpdatedAt: String,
    options: { type: Object, default: {} },
    required: { type: Boolean, default: false },
    disabled: { type: Boolean, default: false },
    disabledMessage: String
  }

  connect() {
    this.isEditing = false
    this.input = null
    this.originalContent = this.element.innerHTML
    this.savingTimeout = null
    this.isDirty = false

    // Translation cache
    this.translations = {
      finishCurrentField: this.t('inline_edit.finish_current_field', 'Please finish editing the current field first.'),
      unsavedChanges: this.t('inline_edit.unsaved_changes', 'You have unsaved changes. Leave anyway?')
    }
  }

  disconnect() {
    if (this.savingTimeout) {
      clearTimeout(this.savingTimeout)
    }

    // Release global locks / listeners if this element owned them
    if (this.ownsGlobalLock()) {
      this.releaseGlobalLock()
    }
    this.clearDirty()
  }

  // Activate edit mode on double-click
  activate(event) {
    if (this.isEditing) return

    // Guard: prevent activation when field is locked (e.g., auto-calculated)
    if (this.disabledValue) {
      event.preventDefault()
      event.stopPropagation()
      if (this.disabledMessageValue) {
        this.showToast(this.disabledMessageValue, 'error')
      }
      return
    }

    // Prevent concurrent edits across different inline-edit instances
    if (window.__inlineEditActiveElement && window.__inlineEditActiveElement !== this.element) {
      event.preventDefault()
      event.stopPropagation()
      this.showToast(this.translations.finishCurrentField, 'error')
      return
    }

    this.acquireGlobalLock()

    event.preventDefault()
    event.stopPropagation()

    this.isEditing = true
    this.originalContent = this.element.innerHTML

    // Store original value if not set
    if (!this.hasOriginalValue) {
      this.originalValue = this.element.textContent.trim()
    }

    // Create and insert input based on type
    this.createInput()
    this.element.innerHTML = ''
    this.element.appendChild(this.input)

    // Focus and select content
    this.input.focus()
    if (this.typeValue !== 'select') {
      this.input.select()
    }

    // Apply edit mode styles
    this.applyEditModeStyles()

    // Mark as dirty while in edit mode to warn on navigation
    this.markDirty()
  }

  createInput() {
    let input

    switch (this.typeValue) {
      case 'textarea':
        input = document.createElement('textarea')
        input.value = this.originalValue
        input.rows = 3
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break

      case 'select':
        input = document.createElement('select')
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'

        // Add options
        Object.entries(this.optionsValue).forEach(([key, label]) => {
          const option = document.createElement('option')
          option.value = key
          option.textContent = label
          if (key === this.originalValue) {
            option.selected = true
          }
          input.appendChild(option)
        })

        // For select, save immediately on change
        input.addEventListener('change', () => this.save())
        break

      case 'number':
        input = document.createElement('input')
        input.type = 'number'
        input.step = '0.01'
        input.value = this.originalValue
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break

      case 'date':
        input = document.createElement('input')
        input.type = 'date'
        input.value = this.originalValue
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break

      case 'email':
        input = document.createElement('input')
        input.type = 'email'
        input.value = this.originalValue
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break

      default: // text
        input = document.createElement('input')
        input.type = 'text'
        input.value = this.originalValue
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break
    }

    // Add event listeners (except select which has its own)
    if (this.typeValue !== 'select') {
      input.addEventListener('keydown', (e) => this.handleKeydown(e))
      input.addEventListener('blur', () => this.handleBlur())
    }

    this.input = input
  }

  handleKeydown(event) {
    if (event.key === 'Enter' && this.typeValue !== 'textarea') {
      event.preventDefault()
      this.save()
    } else if (event.key === 'Escape') {
      event.preventDefault()
      this.cancel()
    }
  }

  handleBlur() {
    // Delay blur to allow click events to fire first
    setTimeout(() => {
      if (this.isEditing) {
        this.save()
      }
    }, 200)
  }

  async save() {
    if (!this.isEditing) return

    const newValue = this.input.value.trim()

    // Client-side validation
    if (this.requiredValue && !newValue) {
      this.showError('This field is required')
      return
    }

    // Check if value actually changed
    if (newValue === this.originalValue) {
      this.cancel()
      return
    }

    // Show loading state
    this.showLoading()

    try {
      // Build request payload
      const payload = {
        [this.modelValue]: {
          [this.fieldValue]: newValue
        },
        record_updated_at: this.recordUpdatedAtValue
      }

      // Send PATCH request
      const response = await fetch(this.urlValue, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
          'Accept': 'application/json'
        },
        body: JSON.stringify(payload)
      })

      const data = await response.json()

    if (response.ok && data.success) {
      // Success!
      this.handleSuccess(newValue, data.data)
    } else if (response.status === 409) {
      // Conflict - optimistic locking failed
      this.handleConflict(data.error)
    } else if (response.status === 422) {
      // Validation error
      this.handleValidationError(data.errors)
    } else {
      // Other error
      this.handleError('Failed to save changes')
    }
  } catch (error) {
      console.error('Inline edit error:', error)
      this.handleError('Network error. Please try again.')
    }
  }

  cancel() {
    if (!this.isEditing) return

    this.isEditing = false
    this.element.innerHTML = this.originalContent
    this.element.classList.remove('border-blue-500', 'border-red-500', 'border-green-500')
    this.clearError()
    this.clearDirty()
    this.releaseGlobalLock()
  }

  handleSuccess(newValue, updatedData) {
    this.stopLoading()
    this.isEditing = false
    const updatedValue = updatedData && Object.prototype.hasOwnProperty.call(updatedData, this.fieldValue)
      ? updatedData[this.fieldValue]
      : newValue

    const displayValue = this.formatDisplayValueForType(this.typeValue, updatedValue, this.optionsValue)

    // Update display with new value
    if (this.typeValue === 'select' && this.optionsValue[updatedValue]) {
      this.element.textContent = this.optionsValue[updatedValue]
    } else {
      this.element.textContent = displayValue
    }

    // Update original value for next edit
    this.originalValue = updatedValue

    // Update record's updated_at timestamp for ALL fields of this record - CRITICAL FOR OPTIMISTIC LOCKING
    if (updatedData && updatedData.updated_at) {
      this.recordUpdatedAtValue = updatedData.updated_at

      // Update ALL other inline-edit fields for the same record URL
      // This ensures all fields stay in sync after any field is updated
      this.updateAllFieldsTimestamp(updatedData.updated_at)

      // Update values across all inline-edit fields for the same record so duplicated displays stay in sync
      this.updateAllFieldsData(updatedData)

      // Update related/parent records if payload includes them (e.g., task values recalculated from subtasks)
      this.updateRelatedRecords(updatedData)
    }

    // Apply success styling (green border flash) - no border-2, just change color
    this.element.classList.remove('border-blue-500', 'border-red-500')
    this.element.classList.add('border-green-500')

    // Show success toast
    this.showToast('Saved successfully', 'success')

    this.clearDirty()
    this.releaseGlobalLock()

    // Remove success styling after 2 seconds
    setTimeout(() => {
      this.element.classList.remove('border-green-500')
    }, 2000)

    this.clearError()
  }

  updateAllFieldsTimestamp(newTimestamp) {
    // Find all inline-edit elements with the same URL (same record)
    const allInlineEditElements = document.querySelectorAll('[data-controller~="inline-edit"]')

    allInlineEditElements.forEach(element => {
      // Check if this element is for the same record (same URL)
      const elementUrl = element.dataset.inlineEditUrlValue

      if (elementUrl === this.urlValue) {
        // Update via dataset which Stimulus watches - this is the key!
        element.dataset.inlineEditRecordUpdatedAtValue = newTimestamp

        // Log for debugging
        console.log(`Updated timestamp for field ${element.dataset.inlineEditFieldValue} to ${newTimestamp}`)
      }
    })
  }

  updateAllFieldsData(updatedData) {
    if (!updatedData) return

    const allInlineEditElements = document.querySelectorAll('[data-controller~="inline-edit"]')

    allInlineEditElements.forEach(element => {
      const elementUrl = element.dataset.inlineEditUrlValue
      const field = element.dataset.inlineEditFieldValue

      if (elementUrl !== this.urlValue) return
      if (!Object.prototype.hasOwnProperty.call(updatedData, field)) return

      const type = element.dataset.inlineEditTypeValue || 'text'
      const optionsRaw = element.dataset.inlineEditOptionsValue
      let options = {}
      if (optionsRaw) {
        try {
          options = JSON.parse(optionsRaw)
        } catch (_) {
          options = {}
        }
      }

      const value = updatedData[field]
      const display = this.formatDisplayValueForType(type, value, options)

      // Update visible text only if element is not currently showing an input
      if (!element.querySelector('input, textarea, select')) {
        element.textContent = display
      }

      // Keep original value in sync for next edit
      element.dataset.inlineEditOriginalValue = value
    })
  }

  updateRelatedRecords(updatedData) {
    if (!updatedData) return

    const relatedRecords = []

    // Current payload shape: data.parent_task from subtask updates
    if (updatedData.parent_task) {
      relatedRecords.push(updatedData.parent_task)
    }

    relatedRecords.forEach(record => {
      this.updateFieldsForUrl(record)
    })
  }

  updateFieldsForUrl(recordData) {
    if (!recordData || !recordData.url) return

    const { url, updated_at: updatedAt, ...fields } = recordData
    const elements = document.querySelectorAll(`[data-controller~="inline-edit"][data-inline-edit-url-value="${url}"]`)

    elements.forEach(element => {
      const field = element.dataset.inlineEditFieldValue
      if (!Object.prototype.hasOwnProperty.call(fields, field)) return

      const type = element.dataset.inlineEditTypeValue || 'text'
      const optionsRaw = element.dataset.inlineEditOptionsValue
      let options = {}
      if (optionsRaw) {
        try {
          options = JSON.parse(optionsRaw)
        } catch (_) {
          options = {}
        }
      }

      const value = fields[field]
      const display = this.formatDisplayValueForType(type, value, options)

      if (!element.querySelector('input, textarea, select')) {
        element.textContent = display
      }

      element.dataset.inlineEditOriginalValue = value
      if (updatedAt) {
        element.dataset.inlineEditRecordUpdatedAtValue = updatedAt
      }
    })
  }

  handleConflict(errorMessage) {
    this.stopLoading()
    const message = errorMessage || 'This record was modified by another user. Please refresh the page to see the latest changes.'

    if (confirm(`${message}\n\nDo you want to refresh the page now?`)) {
      window.location.reload()
    } else {
      this.cancel()
    }
  }

  handleValidationError(errors) {
    this.stopLoading()
    const errorMessage = Array.isArray(errors) ? errors.join(', ') : errors
    this.showError(errorMessage)
    this.showToast(errorMessage, 'error')
    this.markDirty()

    // Keep in edit mode with red border - no border-2, just change color
    this.element.classList.remove('border-blue-500', 'border-green-500')
    this.element.classList.add('border-red-500')
  }

  handleError(message) {
    this.stopLoading()
    this.showError(message)
    this.showToast(message, 'error')
    this.markDirty()

    // Keep in edit mode with red border - no border-2, just change color
    this.element.classList.remove('border-blue-500', 'border-green-500')
    this.element.classList.add('border-red-500')
  }

  showLoading() {
    if (this.input) {
      this.input.disabled = true
      this.input.classList.add('opacity-50', 'cursor-wait')
    }
  }

  stopLoading() {
    if (this.input) {
      this.input.disabled = false
      this.input.classList.remove('opacity-50', 'cursor-wait')
    }
  }

  acquireGlobalLock() {
    window.__inlineEditActiveElement = this.element
    this.lockOwner = true
  }

  releaseGlobalLock() {
    if (this.ownsGlobalLock()) {
      delete window.__inlineEditActiveElement
      this.lockOwner = false
    }
  }

  ownsGlobalLock() {
    return this.lockOwner && window.__inlineEditActiveElement === this.element
  }

  markDirty() {
    if (this.isDirty) return

    this.isDirty = true
    this.boundBeforeUnload ||= (event) => {
      event.preventDefault()
      event.returnValue = this.translations.unsavedChanges
      return this.translations.unsavedChanges
    }
    window.addEventListener('beforeunload', this.boundBeforeUnload)
  }

  clearDirty() {
    if (!this.isDirty) return

    this.isDirty = false
    if (this.boundBeforeUnload) {
      window.removeEventListener('beforeunload', this.boundBeforeUnload)
    }
  }

  t(key, fallback = '') {
    // Simple lookup from meta tag data-i18n JSON if present
    try {
      const el = document.querySelector('meta[name="i18n"]')
      if (!el) return fallback
      const map = JSON.parse(el.content || '{}')
      return map[key] || fallback
    } catch (e) {
      return fallback
    }
  }

  applyEditModeStyles() {
    // Just change border color, don't add border-2
    this.element.classList.add('border-blue-500')
  }

  showError(message) {
    // Remove existing error if present
    this.clearError()

    // Create simple error message element - same style for table cells and forms
    const errorDiv = document.createElement('div')
    errorDiv.dataset.inlineEditError = 'true'
    errorDiv.className = 'inline-edit-error text-red-600 text-xs mt-1 dark:text-red-400'
    errorDiv.textContent = message

    // Check if we're in a table cell
    const isTableCell = this.element.tagName === 'TD'

    if (isTableCell) {
      // For table cells, append inside the cell (will appear below the input)
      this.element.appendChild(errorDiv)
    } else {
      // For form fields, insert after the element
      this.element.parentNode.insertBefore(errorDiv, this.element.nextSibling)
    }
  }

  clearError() {
    // Find and remove error message - check both inside element (table cells) and after element (form fields)
    const errorInside = this.element.querySelector('[data-inline-edit-error="true"]')
    if (errorInside) {
      errorInside.remove()
    }

    const errorAfter = this.element.parentNode?.querySelector('[data-inline-edit-error="true"]')
    if (errorAfter) {
      errorAfter.remove()
    }
  }

  showToast(message, type) {
    const event = new CustomEvent('toast:show', {
      detail: { message, type }
    })
    window.dispatchEvent(event)
  }

  formatDisplayValue(value) {
    return this.formatDisplayValueForType(this.typeValue, value, this.optionsValue)
  }

  formatDisplayValueForType(type, value, options = {}) {
    if (type === 'date') {
      return this.formatDateValue(value)
    }

    if (type === 'select' && options && Object.prototype.hasOwnProperty.call(options, value)) {
      return options[value]
    }

    return value
  }

  // Force dd.mm.yyyy regardless of browser locale to keep inline display consistent
  formatDateValue(value) {
    if (!value) return ''

    // Accept both ISO "yyyy-mm-dd" and already formatted values
    const isoMatch = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value)
    if (isoMatch) {
      const [, year, month, day] = isoMatch
      return `${day}.${month}.${year}`
    }

    // Fallback to Date parsing if something unexpected comes through
    const date = new Date(value)
    if (isNaN(date.getTime())) return value
    const dd = String(date.getDate()).padStart(2, '0')
    const mm = String(date.getMonth() + 1).padStart(2, '0')
    const yyyy = date.getFullYear()
    return `${dd}.${mm}.${yyyy}`
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || ''
  }
}
