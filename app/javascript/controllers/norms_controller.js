import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { subtaskId: Number }

  trackSelection(event) {
    const checkbox = event.target
    const normId = checkbox.value
    const subTaskId = this.subtaskIdValue
    const token = document.querySelector('meta[name="csrf-token"]').content

    const url = `/businesses/${this.getBusinessId()}/projects/${this.getProjectId()}/tasks/${this.getTaskId()}/sub_tasks/${subTaskId}/pinned_norms/${normId}`
    const method = checkbox.checked ? "POST" : "DELETE"

    fetch(url, {
      method: method,
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/json"
      }
    })
  }

  getBusinessId() {
    return window.location.pathname.split("/")[2]
  }

  getProjectId() {
    return window.location.pathname.split("/")[4]
  }

  getTaskId() {
    return window.location.pathname.split("/")[6]
  }
}
