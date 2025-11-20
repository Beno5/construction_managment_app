import { Controller } from "@hotwired/stimulus"

// Sidebar collapse controller - toggles between full and slim mode
export default class extends Controller {
  static targets = ["toggleIcon"]

  connect() {
    // Update toggle icon based on current state (state is already applied via inline script)
    const isCollapsed = document.documentElement.classList.contains("sidebar-collapsed")
    this.updateToggleIcon(isCollapsed)
  }

  toggle() {
    const isCurrentlyCollapsed = document.documentElement.classList.contains("sidebar-collapsed")

    if (isCurrentlyCollapsed) {
      this.expand()
    } else {
      this.collapse()
    }

    // Save state to localStorage
    const userId = this.element.dataset.userId
    if (userId) {
      const storageKey = `sidebar_collapsed_${userId}`
      localStorage.setItem(storageKey, !isCurrentlyCollapsed)
    }
  }

  collapse() {
    document.documentElement.classList.add("sidebar-collapsed")
    this.updateToggleIcon(true)
  }

  expand() {
    document.documentElement.classList.remove("sidebar-collapsed")
    this.updateToggleIcon(false)
  }

  updateToggleIcon(isCollapsed) {
    if (this.hasToggleIconTarget) {
      this.toggleIconTarget.style.transform = isCollapsed ? "rotate(180deg)" : "rotate(0deg)"
    }
  }
}
