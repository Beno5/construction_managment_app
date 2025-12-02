// Import Hotwire Turbo & Stimulus
import "@hotwired/turbo-rails"
import "./controllers"

// Import Flowbite
import "flowbite"
import { initFlowbite } from "flowbite"

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
  // Destroy existing dropdown instances to prevent duplicates
  document.querySelectorAll('[data-dropdown-toggle]').forEach(button => {
    const dropdownId = button.getAttribute('data-dropdown-toggle')
    const dropdown = document.getElementById(dropdownId)
    if (dropdown && dropdown._tippy) {
      dropdown._tippy.destroy()
    }
  })

  // Reinitialize all Flowbite components
  initFlowbite()
}

// Reinitialize Flowbite components after Turbo updates (e.g., search results)
document.addEventListener("turbo:load", reinitializeFlowbite)
document.addEventListener("turbo:frame-load", reinitializeFlowbite)
document.addEventListener("turbo:frame-render", (event) => {
  // Use setTimeout to ensure DOM is fully updated before reinitializing
  setTimeout(reinitializeFlowbite, 10)
})
document.addEventListener("turbo:render", () => {
  // Use setTimeout to ensure DOM is fully updated before reinitializing
  setTimeout(reinitializeFlowbite, 10)
})
