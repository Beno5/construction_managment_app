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

// Reinitialize Flowbite components after Turbo updates (e.g., search results)
document.addEventListener("turbo:load", initFlowbite)
document.addEventListener("turbo:frame-load", initFlowbite)
