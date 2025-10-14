import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const el = document.getElementById("gantt_here")
    if (el && window.gantt) {
      const projectId = el.dataset.projectId
      gantt.clearAll()
      gantt.load(`/api/gantt/project/${projectId}/data`, () => {
        if (typeof gantt.openAll === "function") gantt.openAll()
      })
    }
    this.element.remove()
  }
}
// This controller is used to trigger a refresh of the Gantt chart when a custom event is dispatched.