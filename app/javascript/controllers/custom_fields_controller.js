import { Controller } from "@hotwired/stimulus"

// Manages custom fields: add, remove, and inline editing
// Used for dynamic key-value pairs on Projects, Tasks, SubTasks, etc.
//
// Usage:
//   <div data-controller="custom-fields"
//        data-custom-fields-model-value="task"
//        data-custom-fields-url-value="/path/to/resource"
//        data-custom-fields-record-updated-at-value="<%= record.updated_at.iso8601 %>">
//     ... custom fields display ...
//   </div>
export default class extends Controller {
  static targets = ["container", "template", "addButton"]
  static values = {
    model: String,
    url: String,
    recordUpdatedAt: String,
    editing: { type: Boolean, default: false }
  }

  connect() {
    this.fieldIndex = this.containerTarget.querySelectorAll('[data-custom-field-index]').length
    this.isFormMode = !this.hasUrlValue
    this.isDirty = false
    this.dirtyFields = new Set() // Track which fields are dirty
    this.navigationPending = false // Track if navigation is in progress
    this.navigationCancelled = false // Track if navigation was just cancelled

    // If in inline mode (existing record), add event listeners to inputs
    if (!this.isFormMode) {
      this.setupInlineListeners()
    }
  }

  disconnect() {
    // Clean up dirty state when controller disconnects
    this.clearDirty()
  }

  setupInlineListeners() {
    // Listen for focus events to mark fields as dirty (entering edit mode)
    this.element.addEventListener('focus', (event) => {
      const input = event.target
      const role = input.dataset.customFieldRole

      if (role === 'key' || role === 'value') {
        const row = input.closest('[data-custom-field-row]')
        const rowIndex = row.dataset.customFieldIndex
        this.dirtyFields.add(rowIndex)
        this.markDirty()
      }
    }, true) // Use capture to catch focus events

    // Listen for blur events on key and value inputs for inline saving
    this.element.addEventListener('blur', (event) => {
      const input = event.target
      const role = input.dataset.customFieldRole

      if (role === 'key' || role === 'value') {
        this.handleFieldChange(input)
      }
    }, true) // Use capture to catch blur events

    // Listen for Enter and Escape keys on inputs
    this.element.addEventListener('keydown', (event) => {
      const input = event.target
      const role = input.dataset.customFieldRole

      if (role === 'key' || role === 'value') {
        if (event.key === 'Enter') {
          event.preventDefault()
          this.handleFieldChange(input)
        } else if (event.key === 'Escape') {
          event.preventDefault()
          this.cancelEdit(input)
        }
      }
    }, true)
  }

  cancelEdit(input) {
    const row = input.closest('[data-custom-field-row]')
    const keyInput = row.querySelector('[data-custom-field-role="key"]')
    const valueInput = row.querySelector('[data-custom-field-role="value"]')

    // Restore original values
    const originalKey = keyInput.dataset.customFieldOriginalKey || ''
    const originalValue = valueInput.dataset.originalValue || ''

    keyInput.value = originalKey
    valueInput.value = originalValue

    // Clear dirty state for this field
    const rowIndex = row.dataset.customFieldIndex
    this.dirtyFields.delete(rowIndex)
    if (this.dirtyFields.size === 0) {
      this.clearDirty()
    }

    // Blur the input to exit edit mode
    input.blur()
  }

  async handleFieldChange(input) {
    // If navigation is pending, don't auto-save (user will be prompted)
    if (this.navigationPending) {
      return
    }

    // If navigation was just cancelled, don't clear dirty state yet
    if (this.navigationCancelled) {
      return
    }

    const row = input.closest('[data-custom-field-row]')
    const keyInput = row.querySelector('[data-custom-field-role="key"]')
    const valueInput = row.querySelector('[data-custom-field-role="value"]')
    const originalKey = keyInput.dataset.customFieldOriginalKey || keyInput.value
    const newKey = keyInput.value.trim()
    const newValue = valueInput.value.trim()

    // Don't save if nothing changed or if fields are empty
    if (!newKey || !newValue) {
      // If fields are empty and this is a new field, just clear dirty
      const rowIndex = row.dataset.customFieldIndex
      this.dirtyFields.delete(rowIndex)
      if (this.dirtyFields.size === 0) {
        this.clearDirty()
      }
      return
    }
    if (newKey === originalKey && valueInput.dataset.originalValue === newValue) {
      // Nothing changed, just clear dirty
      const rowIndex = row.dataset.customFieldIndex
      this.dirtyFields.delete(rowIndex)
      if (this.dirtyFields.size === 0) {
        this.clearDirty()
      }
      return
    }

    try {
      // If key changed, we need to delete old key and add new one
      const payload = {
        [this.modelValue]: {
          custom_fields: {}
        },
        record_updated_at: this.recordUpdatedAtValue
      }

      // If key changed, remove the old key
      if (newKey !== originalKey && originalKey) {
        payload[this.modelValue].custom_fields[originalKey] = ''
      }

      // Add/update the field with new key
      payload[this.modelValue].custom_fields[newKey] = newValue

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
        // Update the original key reference
        keyInput.dataset.customFieldOriginalKey = newKey
        valueInput.dataset.originalValue = newValue
        row.dataset.customFieldKey = newKey

        // Update timestamp
        if (data.data && data.data.updated_at) {
          this.recordUpdatedAtValue = data.data.updated_at
        }

        // Clear dirty state for this field
        const rowIndex = row.dataset.customFieldIndex
        this.dirtyFields.delete(rowIndex)
        if (this.dirtyFields.size === 0) {
          this.clearDirty()
        }

        this.showToast(this.t('custom_fields.saved', 'Custom field saved'), 'success')

        // Flash green border
        row.classList.add('border-green-500')
        setTimeout(() => {
          row.classList.remove('border-green-500')
        }, 2000)
      } else if (response.status === 409) {
        alert(data.error || 'This record was modified by another user. Please refresh the page.')
      } else {
        const errorMsg = data.errors ? data.errors.join(', ') : 'Failed to save field'
        this.showToast(errorMsg, 'error')
      }
    } catch (error) {
      console.error('Custom field save error:', error)
      this.showToast('Network error. Please try again.', 'error')
    }
  }

  // Add a new custom field input pair (form mode)
  addField() {
    const newField = this.createFieldElement(this.fieldIndex, '', '')
    this.containerTarget.appendChild(newField)
    this.fieldIndex++

    // Focus on the key input
    const keyInput = newField.querySelector('input[name*="[key]"]')
    if (keyInput) keyInput.focus()

    // Trigger form change tracking
    this.dispatchFormChange()
  }

  // Add a new custom field for existing record (inline mode)
  async addFieldInline() {
    // Prompt user for field name and value
    const key = prompt(this.t('custom_fields.enter_field_name', 'Enter field name:'))
    if (!key || key.trim() === '') return

    const value = prompt(this.t('custom_fields.enter_field_value', 'Enter field value:'))
    if (!value || value.trim() === '') return

    try {
      const payload = {
        [this.modelValue]: {
          custom_fields: {
            [key.trim()]: value.trim()
          }
        },
        record_updated_at: this.recordUpdatedAtValue
      }

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
        // Reload page to show new field
        window.location.reload()
      } else if (response.status === 409) {
        alert(data.error || 'This record was modified by another user. Please refresh the page.')
      } else {
        const errorMsg = data.errors ? data.errors.join(', ') : 'Failed to add field'
        this.showToast(errorMsg, 'error')
      }
    } catch (error) {
      console.error('Custom field add error:', error)
      this.showToast('Network error. Please try again.', 'error')
    }
  }

  // Remove a custom field
  removeField(event) {
    const fieldElement = event.target.closest('[data-custom-field-row]')
    if (fieldElement) {
      fieldElement.remove()
      this.dispatchFormChange()
    }
  }

  // Update a custom field value via inline editing (for existing records)
  async updateField(event) {
    const fieldElement = event.target.closest('[data-custom-field-row]')
    const key = fieldElement.dataset.customFieldKey
    const valueDisplay = fieldElement.querySelector('[data-custom-field-value-display]')
    const currentValue = valueDisplay.dataset.customFieldValue || valueDisplay.textContent.trim()

    // Show loading state
    valueDisplay.classList.add('opacity-50', 'cursor-wait')

    try {
      const payload = {
        [this.modelValue]: {
          custom_fields: {
            [key]: event.target.value
          }
        },
        record_updated_at: this.recordUpdatedAtValue
      }

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
        // Update display
        valueDisplay.textContent = event.target.value
        valueDisplay.dataset.customFieldValue = event.target.value

        // Update timestamp
        if (data.data && data.data.updated_at) {
          this.recordUpdatedAtValue = data.data.updated_at
        }

        // Show success toast
        this.showToast('Saved successfully', 'success')

        // Flash green border
        fieldElement.classList.add('border-2', 'border-green-500')
        setTimeout(() => {
          fieldElement.classList.remove('border-2', 'border-green-500')
        }, 2000)
      } else if (response.status === 409) {
        // Conflict
        alert(data.error || 'This record was modified by another user. Please refresh the page.')
      } else {
        // Error
        const errorMsg = data.errors ? data.errors.join(', ') : 'Failed to save'
        this.showToast(errorMsg, 'error')
      }
    } catch (error) {
      console.error('Custom field update error:', error)
      this.showToast('Network error. Please try again.', 'error')
    } finally {
      valueDisplay.classList.remove('opacity-50', 'cursor-wait')
    }
  }

  // Delete a custom field from an existing record
  async deleteField(event) {
    const fieldElement = event.target.closest('[data-custom-field-row]')
    const key = fieldElement.dataset.customFieldKey

    if (!confirm(`Remove custom field "${key}"?`)) return

    // Show loading state
    fieldElement.classList.add('opacity-50', 'pointer-events-none')

    try {
      // Send update with empty value to remove the field
      const payload = {
        [this.modelValue]: {
          custom_fields: {
            [key]: '' // Empty value will be sanitized/removed by backend
          }
        },
        record_updated_at: this.recordUpdatedAtValue
      }

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
        // Clear dirty state for this field
        const rowIndex = fieldElement.dataset.customFieldIndex
        this.dirtyFields.delete(rowIndex)
        if (this.dirtyFields.size === 0) {
          this.clearDirty()
        }

        // Remove element with fade animation
        fieldElement.style.transition = 'opacity 0.3s'
        fieldElement.style.opacity = '0'
        setTimeout(() => fieldElement.remove(), 300)

        // Update timestamp
        if (data.data && data.data.updated_at) {
          this.recordUpdatedAtValue = data.data.updated_at
        }

        this.showToast('Custom field removed', 'success')
      } else if (response.status === 409) {
        alert(data.error || 'This record was modified by another user. Please refresh the page.')
        fieldElement.classList.remove('opacity-50', 'pointer-events-none')
      } else {
        const errorMsg = data.errors ? data.errors.join(', ') : 'Failed to remove field'
        this.showToast(errorMsg, 'error')
        fieldElement.classList.remove('opacity-50', 'pointer-events-none')
      }
    } catch (error) {
      console.error('Custom field delete error:', error)
      this.showToast('Network error. Please try again.', 'error')
      fieldElement.classList.remove('opacity-50', 'pointer-events-none')
    }
  }

  // Create a new field element (for both form and inline mode)
  createFieldElement(index, key = '', value = '') {
    const div = document.createElement('div')
    div.dataset.customFieldRow = ''
    div.dataset.customFieldIndex = index
    if (key && !this.isFormMode) {
      div.dataset.customFieldKey = key
    }
    div.className = 'flex items-center gap-3 mb-3 p-3 bg-gray-50 dark:bg-gray-700 rounded-lg border border-gray-200 dark:border-gray-600'

    const fieldNamePlaceholder = this.t('custom_fields.field_name_placeholder', 'Field name')
    const valuePlaceholder = this.t('custom_fields.value_placeholder', 'Value')
    const removeTitle = this.t('custom_fields.remove', 'Remove field')

    const trackChangesAction = this.isFormMode ? 'input->track-changes#markChanged' : ''
    const trackChangesTarget = this.isFormMode ? 'track-changes' : ''

    div.innerHTML = `
      <div class="flex-1 grid grid-cols-2 gap-3">
        <div>
          <input type="text"
                 name="${this.modelValue}[custom_fields][${index}][key]"
                 value="${this.escapeHtml(key)}"
                 placeholder="${fieldNamePlaceholder}"
                 class="w-full px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:text-white dark:placeholder-gray-400"
                 ${trackChangesAction ? `data-action="${trackChangesAction}"` : ''}
                 ${trackChangesTarget ? `data-${trackChangesTarget}-target="input"` : ''}
                 data-custom-field-role="key"
                 data-custom-field-original-key="${this.escapeHtml(key)}"
                 required>
        </div>
        <div>
          <input type="text"
                 name="${this.modelValue}[custom_fields][${index}][value]"
                 value="${this.escapeHtml(value)}"
                 placeholder="${valuePlaceholder}"
                 class="w-full px-3 py-2 text-sm text-gray-900 bg-white border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:text-white dark:placeholder-gray-400"
                 ${trackChangesAction ? `data-action="${trackChangesAction}"` : ''}
                 ${trackChangesTarget ? `data-${trackChangesTarget}-target="input"` : ''}
                 data-custom-field-role="value"
                 data-original-value="${this.escapeHtml(value)}"
                 required>
        </div>
      </div>
      <button type="button"
              class="flex-shrink-0 p-2 text-red-600 hover:text-red-800 hover:bg-red-50 rounded-lg transition dark:text-red-400 dark:hover:bg-red-900/20"
              data-action="click->custom-fields#${this.isFormMode ? 'removeField' : 'deleteField'}"
              title="${removeTitle}">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
        </svg>
      </button>
    `

    return div
  }

  // Simple translation helper
  t(key, fallback = '') {
    try {
      const el = document.querySelector('meta[name="i18n"]')
      if (!el) return fallback
      const map = JSON.parse(el.content || '{}')
      return map[key] || fallback
    } catch (e) {
      return fallback
    }
  }

  // Dispatch form change event to trigger save button
  dispatchFormChange() {
    const event = new Event('input', { bubbles: true })
    const trackChangesElement = document.querySelector('[data-controller~="track-changes"]')
    if (trackChangesElement) {
      trackChangesElement.dispatchEvent(event)
    }
  }

  showToast(message, type) {
    const event = new CustomEvent('toast:show', {
      detail: { message, type }
    })
    window.dispatchEvent(event)
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }

  markDirty() {
    if (this.isDirty) return

    this.isDirty = true
    this.boundBeforeUnload = (event) => {
      const message = this.t('custom_fields.unsaved_changes', 'You have unsaved changes in custom fields. Leave anyway?')
      event.preventDefault()
      event.returnValue = message
      return message
    }
    window.addEventListener('beforeunload', this.boundBeforeUnload)

    // Turbo navigation guard (prompts before leaving while editing)
    this.boundTurboBeforeVisit ||= (event) => this.handleTurboBeforeVisit(event)
    window.addEventListener('turbo:before-visit', this.boundTurboBeforeVisit)
  }

  clearDirty() {
    if (!this.isDirty) return

    this.isDirty = false
    this.dirtyFields.clear()
    this.navigationPending = false // Reset navigation flag
    this.navigationCancelled = false // Reset navigation cancelled flag
    if (this.boundBeforeUnload) {
      window.removeEventListener('beforeunload', this.boundBeforeUnload)
      this.boundBeforeUnload = null
    }
    if (this.boundTurboBeforeVisit) {
      window.removeEventListener('turbo:before-visit', this.boundTurboBeforeVisit)
    }
  }

  handleTurboBeforeVisit(event) {
    if (!this.isDirty) return

    // Set flag to prevent blur handler from auto-saving during navigation
    this.navigationPending = true

    const message = this.t('custom_fields.unsaved_changes', 'You have unsaved changes in custom fields. Leave anyway?')
    if (!window.confirm(message)) {
      // User cancelled navigation, reset flags
      this.navigationPending = false
      this.navigationCancelled = true
      event.preventDefault()
      event.stopImmediatePropagation()

      // Reset the navigationCancelled flag after a short delay
      // This allows any pending blur events to be processed without clearing dirty state
      setTimeout(() => {
        this.navigationCancelled = false
      }, 100)
    } else {
      // User confirmed, clear dirty and allow navigation
      this.clearDirty()
    }
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || ''
  }
}
