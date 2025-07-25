import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { subtaskId: Number }
  static targets = ["duration", "skilled", "unskilled", "machines"]

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
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.durationTarget.value = data.duration
        this.skilledTarget.value = data.num_workers_skilled
        this.unskilledTarget.value = data.num_workers_unskilled
        this.machinesTarget.value = data.num_machines

        // 🔁 Ručno pokreni recalculaciju u subtask kontroleru
        const subtaskController = this.application.getControllerForElementAndIdentifier(this.element, "subtask")
        if (subtaskController) {
          subtaskController.recalculate()
        }
      }
    })
    .catch(error => console.error("Error updating norms:", error))
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
