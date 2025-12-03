// Import Hotwire Turbo & Stimulus
import "@hotwired/turbo-rails"
import "./controllers"

// Import Flowbite
import "flowbite"
import { initFlowbite, Dropdown } from "flowbite"

// Store dropdown instances globally to manage them
window.flowbiteDropdowns = window.flowbiteDropdowns || new Map()

// Import custom modules
import "./custom/constants"
import "./custom/dark-mode"
import "./custom/sidebar"
import "./custom/flash"
import "./custom/modals"
import "./custom/custom_confirm"
import "./custom/gant"

// Helper function to reinitialize Flowbite with proper cleanup
function reinitializeFlowbite() {
  // Clear all existing dropdown instances
  window.flowbiteDropdowns.forEach((dropdown, key) => {
    try {
      dropdown.hide()
    } catch (e) {
      // Silently ignore if hide fails
    }
  })
  window.flowbiteDropdowns.clear()

  // Manually initialize all dropdowns with proper instance tracking
  document.querySelectorAll('[data-dropdown-toggle]').forEach(button => {
    const dropdownId = button.getAttribute('data-dropdown-toggle')
    const dropdown = document.getElementById(dropdownId)

    if (dropdown && !window.flowbiteDropdowns.has(dropdownId)) {
      try {
        // Create new Dropdown instance
        const dropdownInstance = new Dropdown(dropdown, button, {
          placement: 'bottom',
          triggerType: 'click',
          offsetSkidding: 0,
          offsetDistance: 10,
          delay: 300
        })

        // Store instance for later cleanup
        window.flowbiteDropdowns.set(dropdownId, dropdownInstance)
      } catch (e) {
        // If manual initialization fails, fall back to initFlowbite
        console.warn('Failed to initialize dropdown:', dropdownId, e)
      }
    }
  })

  // Also run initFlowbite for other components (modals, tooltips, etc.)
  initFlowbite()
}

// Reinitialize Flowbite components after Turbo updates (e.g., search results)
document.addEventListener("turbo:load", reinitializeFlowbite)
document.addEventListener("turbo:frame-load", () => {
  // Use longer timeout to ensure DOM is fully updated
  setTimeout(reinitializeFlowbite, 50)
})
document.addEventListener("turbo:frame-render", () => {
  // Use longer timeout to ensure DOM is fully updated before reinitializing
  setTimeout(reinitializeFlowbite, 50)
})
document.addEventListener("turbo:render", () => {
  // Use longer timeout to ensure DOM is fully updated before reinitializing
  setTimeout(reinitializeFlowbite, 50)
})

// Also listen for turbo:before-stream-render to catch turbo stream updates
document.addEventListener("turbo:before-stream-render", () => {
  setTimeout(reinitializeFlowbite, 100)
})
