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
  const fields = [
    { target: 'duration', value: data.duration },
    { target: 'skilled', value: data.num_workers_skilled },
    { target: 'unskilled', value: data.num_workers_unskilled },
    { target: 'machines', value: data.num_machines }
  ];

  fields.forEach(({ target, value }) => {
    const el = document.querySelector(`[data-subtask-target="${target}"]`);
    if (el) {
      el.value = value;
      el.disabled = !(value > 0);
    }
  });
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
console.log("🎉 123 li");
