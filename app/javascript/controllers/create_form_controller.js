import { Controller } from "@hotwired/stimulus"

// Create form controller - handles validation on submit
// Button is ALWAYS enabled, validation happens when user clicks submit
// Shows inline errors below fields + toast notification at top
//
// Usage:
//   <form data-controller="create-form" data-action="submit->create-form#validate">
//     <input type="text" required name="task[name]" data-create-form-target="input">
//     <button type="submit">Create</button>
//   </form>

export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    // Controller connected and ready
  }

  validate(event) {
    // Clear any previous errors
    this.clearAllErrors()

    let hasErrors = false
    const errorFields = []

    // Check each required field
    this.inputTargets.forEach(input => {
      if (input.hasAttribute('required') && input.value.trim() === '') {
        hasErrors = true
        const fieldLabel = this.getFieldLabel(input)
        const errorMessage = this.t('errors.messages.blank', 'This field is required')

        this.showError(input, errorMessage)
        errorFields.push(fieldLabel)
      }
    })

    if (hasErrors) {
      event.preventDefault()
      event.stopPropagation()
      this.disableSubmit(false)

      // Show toast notification at top with i18n
      const toastMessage = this.t('errors.messages.validation_failed', 'Please fix the errors below')
      this.showToast(toastMessage, 'error')
    } else {
      this.disableSubmit(false)
    }
  }

  getFieldLabel(input) {
    // Try to find associated label
    const label = input.closest('.col-span-6, .col-span-3')?.querySelector('label')
    if (label) {
      return label.textContent.replace('*', '').trim()
    }

    // Fallback to input name
    const name = input.name.split('[').pop().replace(']', '')
    return name.replace('_', ' ').charAt(0).toUpperCase() + name.slice(1)
  }

  showError(input, message) {
    // Add error styling to input
    input.classList.add('border-red-500', 'dark:border-red-500')
    input.classList.remove('border-gray-300', 'dark:border-gray-600')

    // Create error message element
    const errorDiv = document.createElement('div')
    errorDiv.className = 'create-form-error text-red-600 text-xs mt-1 dark:text-red-400'
    errorDiv.textContent = message
    errorDiv.dataset.errorFor = input.name

    // Insert error after input - find the parent container div, not the input itself
    const parent = input.closest('div.col-span-6, div.col-span-3, div.w-full')

    if (parent) {
      parent.appendChild(errorDiv)
    } else {
      input.parentNode.insertBefore(errorDiv, input.nextSibling)
    }
  }

  clearError(input) {
    // Remove error styling
    input.classList.remove('border-red-500', 'dark:border-red-500')
    input.classList.add('border-gray-300', 'dark:border-gray-600')

    // Remove error message
    const parent = input.closest('div.col-span-6, div.col-span-3, div.w-full') || input.parentNode
    const error = parent.querySelector(`[data-error-for="${input.name}"]`)
    if (error) {
      error.remove()
    }
  }

  clearAllErrors() {
    // Remove all error styling and messages
    this.inputTargets.forEach(input => this.clearError(input))

    // Remove any orphaned error divs
    document.querySelectorAll('.create-form-error').forEach(el => el.remove())
  }

  disableSubmit(state) {
    if (!this.hasSubmitTarget) return
    this.submitTarget.disabled = state
    this.submitTarget.classList.toggle('opacity-50', state)
    this.submitTarget.classList.toggle('cursor-not-allowed', state)
  }

  showToast(message, type) {
    const event = new CustomEvent('toast:show', {
      detail: { message, type }
    })
    window.dispatchEvent(event)
  }

  t(key, fallback = '') {
    // Simple i18n lookup from meta tag
    try {
      const el = document.querySelector('meta[name="i18n"]')
      if (!el) return fallback

      const map = JSON.parse(el.content || '{}')
      return map[key] || fallback
    } catch (e) {
      return fallback
    }
  }
}
