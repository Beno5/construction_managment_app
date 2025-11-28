import { Controller } from "@hotwired/stimulus"

// Generic inline edit controller for any model
// Supports single-click activation, multiple field types, validation, and optimistic locking
//
// Usage:
//   <div data-controller="inline-edit"
//        data-inline-edit-model-value="worker"
//        data-inline-edit-field-value="first_name"
//        data-inline-edit-type-value="text"
//        data-inline-edit-url-value="/businesses/1/workers/123"
//        data-inline-edit-original-value="<%= worker.first_name %>"
//        data-inline-edit-record-updated-at-value="<%= worker.updated_at.iso8601 %>"
//        data-action="click->inline-edit#activate">
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

    // Debug i18n on first connect
    if (!window.__i18nDebugLogged) {
      const metaTag = document.querySelector('meta[name="i18n"]')
      const locale = document.documentElement.dataset.locale
      console.log('=== i18n Debug ===')
      console.log('Current locale:', locale)
      console.log('i18n meta tag found:', !!metaTag)
      if (metaTag) {
        console.log('i18n meta tag content:', metaTag.content)
        try {
          const parsed = JSON.parse(metaTag.content)
          console.log('Parsed i18n data:', parsed)
        } catch (e) {
          console.error('Error parsing i18n meta tag:', e)
        }
      }
      window.__i18nDebugLogged = true
    }

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

  // Activate edit mode on click
  async activate(event) {
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

    // If another field is being edited, save it first before activating this one
    if (window.__inlineEditActiveElement && window.__inlineEditActiveElement !== this.element) {
      event.preventDefault()
      event.stopPropagation()

      // Get the controller of the currently active element
      const activeController = this.application.getControllerForElementAndIdentifier(
        window.__inlineEditActiveElement,
        'inline-edit'
      )

      if (activeController) {
        // Save the active field and wait for completion
        await activeController.save()

        // If the save had an error (field still in edit mode), don't proceed
        if (activeController.isEditing) {
          this.showToast(this.translations.finishCurrentField, 'error')
          return
        }
      }
    }

    this.acquireGlobalLock()

    event.preventDefault()
    event.stopPropagation()

    this.isEditing = true
    this.originalContent = this.element.innerHTML
    this.element.dataset.inlineEditActive = 'true'

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

        // For select, save on change (when value actually changes)
        input.addEventListener('change', () => this.save())
        // Also add keydown for Enter (save) and Escape (cancel)
        input.addEventListener('keydown', (e) => this.handleKeydown(e))
        // Add blur to save when clicking away (even if same value selected)
        input.addEventListener('blur', () => this.handleBlur())
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

      case 'password':
        input = document.createElement('input')
        input.type = 'password'
        input.value = this.originalValue
        input.placeholder = this.placeholderValue || ''
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break

      default: // text
        input = document.createElement('input')
        input.type = 'text'
        input.value = this.originalValue
        input.className = 'w-full px-2 py-1 text-sm border-2 border-blue-500 rounded focus:outline-none focus:ring-2 focus:ring-blue-300 dark:bg-gray-700 dark:text-white dark:border-blue-400'
        break
    }

    // Add event listeners (select already has its own listeners added in its case)
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
      const errorMessage = this.t('errors.messages.blank', 'This field is required')
      this.showError(errorMessage)
      this.showToast(errorMessage, 'error')

      // Apply error styling
      this.element.classList.remove('border-blue-500', 'border-green-500')
      this.element.classList.add('border-red-500')
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
      // Build request payload - handle nested fields (e.g., custom_fields.key)
      const payload = {
        [this.modelValue]: this.buildNestedPayload(this.fieldValue, newValue),
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
    this.element.dataset.inlineEditActive = 'false'
  }

  handleSuccess(newValue, updatedData) {
    this.stopLoading()
    this.isEditing = false
    this.element.dataset.inlineEditActive = 'false'
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
    // For password fields, keep originalValue empty for security
    if (this.typeValue === 'password') {
      this.originalValue = ''
    } else {
      this.originalValue = updatedValue
    }

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

    // Show success toast with i18n
    const successMessage = this.t('inline_edit.saved_successfully', 'Saved successfully')
    this.showToast(successMessage, 'success')

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

      // Handle nested fields (e.g., "custom_fields.field_name")
      const value = this.getNestedValue(updatedData, field)
      if (value === undefined) return

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

      const display = this.formatDisplayValueForType(type, value, options)

      // Update visible text only if element is not currently showing an input
      if (!element.querySelector('input, textarea, select')) {
        element.textContent = display
      }

      // Keep original value in sync for next edit
      element.dataset.inlineEditOriginalValue = value
    })
  }

  // Get nested value from object using dot notation (e.g., "custom_fields.field_name")
  getNestedValue(obj, path) {
    const keys = path.split('.')
    let current = obj

    for (const key of keys) {
      if (current === null || current === undefined) {
        return undefined
      }
      current = current[key]
    }

    return current
  }

  updateRelatedRecords(updatedData) {
    if (!updatedData) return

    console.log('updateRelatedRecords called with:', updatedData)

    const relatedRecords = []

    // Handle task data from subtask updates
    if (updatedData.task) {
      console.log('Found task data:', updatedData.task)
      relatedRecords.push(updatedData.task)
    }

    // Handle parent_task (legacy support)
    if (updatedData.parent_task) {
      console.log('Found parent_task data:', updatedData.parent_task)
      relatedRecords.push(updatedData.parent_task)
    }

    console.log('Related records to update:', relatedRecords)

    relatedRecords.forEach(record => {
      this.updateFieldsForUrl(record)
    })
  }

  updateFieldsForUrl(recordData) {
    if (!recordData || !recordData.url) {
      console.log('updateFieldsForUrl: no recordData or url', recordData)
      return
    }

    const { url, updated_at: updatedAt, ...fields } = recordData
    console.log('updateFieldsForUrl - looking for elements with URL:', url)
    console.log('updateFieldsForUrl - fields to update:', fields)

    // Strip query parameters from the URL for matching (handles ?locale=sr variations)
    const baseUrl = url.split('?')[0]
    console.log('updateFieldsForUrl - base URL without query params:', baseUrl)

    // Find all inline-edit elements and filter by matching base URL
    const allElements = document.querySelectorAll('[data-controller~="inline-edit"]')
    const elements = Array.from(allElements).filter(el => {
      const elementUrl = el.dataset.inlineEditUrlValue
      const elementBaseUrl = elementUrl ? elementUrl.split('?')[0] : ''
      return elementBaseUrl === baseUrl
    })

    console.log('updateFieldsForUrl - found elements:', elements.length, elements)

    elements.forEach(element => {
      const field = element.dataset.inlineEditFieldValue
      console.log('updateFieldsForUrl - checking field:', field)

      // Handle nested fields (e.g., "custom_fields.field_name")
      const value = this.getNestedValue(fields, field)
      if (value === undefined) {
        console.log('updateFieldsForUrl - field not in data, skipping:', field)
        return
      }

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

      const display = this.formatDisplayValueForType(type, value, options)

      console.log('updateFieldsForUrl - updating field:', field, 'with value:', value, 'display:', display)

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

    // Handle different error formats
    let errorMessage
    if (Array.isArray(errors)) {
      errorMessage = errors.join(', ')
    } else if (typeof errors === 'object' && errors !== null) {
      // Rails sends errors as {field: ["error1", "error2"]}
      // Extract all error messages from all fields
      const allErrors = Object.values(errors).flat()
      errorMessage = allErrors.join(', ')
    } else {
      errorMessage = String(errors)
    }

    const i18nErrorMessage = this.t('errors.messages.validation_failed', 'Validation failed')

    // Show error below field with i18n
    this.showError(errorMessage)

    // Show toast notification at top
    this.showToast(`${i18nErrorMessage}: ${errorMessage}`, 'error')
    this.markDirty()

    // Keep in edit mode with red border - no border-2, just change color
    this.element.classList.remove('border-blue-500', 'border-green-500')
    this.element.classList.add('border-red-500')
  }

  handleError(message) {
    this.stopLoading()

    // Show error below field with i18n
    const i18nErrorMessage = this.t('errors.messages.blank', 'This field is required')
    this.showError(i18nErrorMessage)

    // Show toast notification at top
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

    // Turbo navigation guard (prompts before leaving while editing)
    this.boundTurboBeforeVisit ||= (event) => this.handleTurboBeforeVisit(event)
    window.addEventListener('turbo:before-visit', this.boundTurboBeforeVisit)
  }

  clearDirty() {
    if (!this.isDirty) return

    this.isDirty = false
    if (this.boundBeforeUnload) {
      window.removeEventListener('beforeunload', this.boundBeforeUnload)
    }
    if (this.boundTurboBeforeVisit) {
      window.removeEventListener('turbo:before-visit', this.boundTurboBeforeVisit)
    }
  }

  handleTurboBeforeVisit(event) {
    if (!this.isDirty) return

    const message = this.translations.unsavedChanges || 'You have unsaved changes. Leave anyway?'
    if (!window.confirm(message)) {
      event.preventDefault()
      event.stopImmediatePropagation()
    } else {
      this.clearDirty()
    }
  }

  t(key, fallback = '') {
    // Simple lookup from meta tag data-i18n JSON if present
    try {
      const el = document.querySelector('meta[name="i18n"]')
      if (!el) {
        console.warn('i18n meta tag not found, using fallback:', fallback)
        return fallback
      }
      const map = JSON.parse(el.content || '{}')
      const translation = map[key]

      if (!translation) {
        console.warn(`Translation not found for key: ${key}, using fallback:`, fallback)
        return fallback
      }

      console.log(`Translation for ${key}:`, translation)
      return translation
    } catch (e) {
      console.error('Error reading i18n translations:', e)
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

    // For password fields, always show asterisks instead of the actual value
    if (type === 'password') {
      return '••••••••'
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

  // Build nested payload for fields like "custom_fields.key"
  buildNestedPayload(fieldPath, value) {
    const parts = fieldPath.split('.')

    if (parts.length === 1) {
      // Simple field: {field: value}
      return { [fieldPath]: value }
    }

    // Nested field: {custom_fields: {key: value}}
    const result = {}
    let current = result

    for (let i = 0; i < parts.length - 1; i++) {
      current[parts[i]] = {}
      current = current[parts[i]]
    }

    current[parts[parts.length - 1]] = value
    return result
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || ''
  }
}
