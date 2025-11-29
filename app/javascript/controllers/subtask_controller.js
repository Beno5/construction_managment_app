import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["duration", "skilled", "unskilled", "machines", "formattedDuration"]
  static values = {
    updateUrl: String
  }

  connect() {
    if (!this.updateUrlValue) {
      console.error("Subtask update URL not found in data-subtask-update-url-value.");
    }
  }

  recalculate() {
    const url = this.updateUrlValue;

    const data = {
      sub_task: {
        duration: parseFloat(this.durationTarget.value) || 0,
        num_workers_skilled: parseFloat(this.skilledTarget.value) || 0,
        num_workers_unskilled: parseFloat(this.unskilledTarget.value) || 0,
        num_machines: parseFloat(this.machinesTarget.value) || 0
      }
    };

    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify(data)
    })
      .then(response => {
        if (!response.ok) throw new Error(`Server error: ${response.status}`);
        return response.json();
      })
      .then(data => {
        if (data.success) {
          this.durationTarget.value = data.duration;
          this.skilledTarget.value = data.num_workers_skilled;
          this.unskilledTarget.value = data.num_workers_unskilled;
          this.machinesTarget.value = data.num_machines;
          if (this.hasFormattedDurationTarget && data.formatted_duration) {
            this.formattedDurationTarget.textContent = data.formatted_duration;
          }

          if (data.planned_start_date) {
            document.querySelector('[data-subtask-target="plannedStart"]').textContent =
              this.formatDate(data.planned_start_date);
          }
          if (data.planned_end_date) {
            document.querySelector('[data-subtask-target="plannedEnd"]').textContent =
              this.formatDate(data.planned_end_date);
          }

        } else {
          console.error("Backend returned failure:", data);
        }
      })
      .catch(error => {
        console.error("Fetch error:", error);
      });
  }

  formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString("de-DE", {
      year: "numeric",
      month: "long",
      day: "numeric"
    });
  }
}
