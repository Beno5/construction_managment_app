import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="track-changes"
export default class extends Controller {
  static targets = ["input", "saveButton"]

  connect() {
    // Snimi originalne vrijednosti
    this.originalValues = this.inputTargets.map(el => this._valueOf(el))
  }

  markChanged() {
    const changed = this.inputTargets.some((el, i) => this._valueOf(el) !== this.originalValues[i])

    if (changed) {
      this.saveButtonTarget.classList.remove("hidden")
    } else {
      this.saveButtonTarget.classList.add("hidden")
    }
  }

  reset() {
    // Nakon submit-a resetujemo originalne vrijednosti
    this.originalValues = this.inputTargets.map(el => this._valueOf(el))
    this.saveButtonTarget.classList.add("hidden")
  }

  _valueOf(el) {
    if (el.type === "checkbox" || el.type === "radio") {
      return el.checked
    } else {
      return el.value
    }
  }
}
