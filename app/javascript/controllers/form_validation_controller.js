import { Controller } from "@hotwired/stimulus"

// Form validation controller for create mode
// Handles:
// - Required field validation
// - Submit button enable/disable
// - Inline error display
// - Form submission
//
// Usage:
//   <form data-controller="form-validation" data-action="submit->form-validation#submit">
//     <input type="text" required data-form-validation-target="input" data-action="input->form-validation#validate">
//     <button type="submit" data-form-validation-target="submitButton">Create</button>
//   </form>

export default class extends Controller {
  static targets = ["input", "submitButton"]

  connect() {
    console.log("Form validation controller connected")
    this.validate()
  }

  validate() {
    // Check if all required fields are filled
    const allValid = this.inputTargets.every(input => {
      if (input.hasAttribute('required')) {
        return input.value.trim() !== ''
      }
      return true
    })

    // Enable/disable submit button
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = !allValid

      if (allValid) {
        this.submitButtonTarget.classList.remove('opacity-50', 'cursor-not-allowed')
        this.submitButtonTarget.classList.add('hover:bg-primary-800', 'focus:ring-4', 'focus:ring-primary-300')
      } else {
        this.submitButtonTarget.classList.add('opacity-50', 'cursor-not-allowed')
        this.submitButtonTarget.classList.remove('hover:bg-primary-800', 'focus:ring-4', 'focus:ring-primary-300')
      }
    }
  }

  submit(event) {
    // Additional validation before submit
    const allValid = this.inputTargets.every(input => {
      if (input.hasAttribute('required')) {
        const isValid = input.value.trim() !== ''

        if (!isValid) {
          this.showError(input, 'This field is required')
        } else {
          this.clearError(input)
        }

        return isValid
      }
      return true
    })

    if (!allValid) {
      event.preventDefault()
      event.stopPropagation()
    }
  }

  showError(input, message) {
    // Clear existing error
    this.clearError(input)

    // Add error styling to input
    input.classList.add('border-red-500', 'dark:border-red-500')
    input.classList.remove('border-gray-300', 'dark:border-gray-600')

    // Create error message
    const errorDiv = document.createElement('div')
    errorDiv.className = 'form-validation-error text-red-600 text-xs mt-1 dark:text-red-400'
    errorDiv.textContent = message
    errorDiv.dataset.errorFor = input.name

    // Insert after input or after parent div
    const parent = input.closest('.col-span-6, .col-span-3, .w-full')
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
    const parent = input.closest('.col-span-6, .col-span-3, .w-full') || input.parentNode
    const error = parent.querySelector(`[data-error-for="${input.name}"]`)
    if (error) {
      error.remove()
    }
  }

  clearAllErrors() {
    this.inputTargets.forEach(input => this.clearError(input))
  }
}
