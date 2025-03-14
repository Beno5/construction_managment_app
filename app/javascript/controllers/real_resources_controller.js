import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    // Dodajemo listener za otvaranje modala
    document.querySelectorAll('.real-resources-modal').forEach(link => {
      link.addEventListener('click', this.updateFields.bind(this));
    });
  }


  updateFields(event) {
    const realActivityId_from_button = event.target.dataset.id;
    const realActivityId = document.querySelector("[name='real_activity[real_activity_id]']").value = realActivityId_from_button;
    const modal = document.querySelector('#real_resource-modal'); // Replace with your modal's ID or a more specific selector
    const form = modal.querySelector("form");
    const submitButton = form.querySelector("input[type='submit']");
    const activityId = event.target.dataset.activityId;
  
    if (realActivityId) {
      submitButton.value = "Ažuriraj Aktivnost";
    } else {
      submitButton.value = "Dodaj Aktivnost";
    }
  
    const quantityField = document.querySelector("[name='real_activity[quantity]']");
    const pricePerUnitField = document.querySelector("[name='real_activity[price_per_unit]']");
    const totalCostField = document.querySelector("[name='real_activity[total_cost]']");
  
    if (quantityField) {
      quantityField.addEventListener('input', () => {
        const quantity = parseFloat(quantityField.value) || 0; // Get quantity
        const pricePerUnit = parseFloat(pricePerUnitField.value) || 0; // Get price per unit
        const total = quantity * pricePerUnit; // Calculate total
        if (totalCostField) totalCostField.value = total.toFixed(2); // Set total cost
      });
    }
  
    fetch(`/fetch_data/get_activity_and_real_activity_infos/${activityId}/${realActivityId_from_button}`)
      .then(response => response.json())
      .then(data => {
        const nameField = document.querySelector("[name='real_activity[name]']");
        const unitOfMeasureField = document.querySelector("[name='real_activity[unit_of_measure]']");
        const startDateField = document.querySelector("[name='real_activity[start_date]']");
        const endDateField = document.querySelector("[name='real_activity[end_date]']");
  
        // Populate read-only fields
        if (nameField) nameField.value = data.name || '';
        if (pricePerUnitField) pricePerUnitField.value = data.price_per_unit || '';
        if (unitOfMeasureField) unitOfMeasureField.value = data.unit_of_measure || '';
        if (quantityField) quantityField.value = data.quantity || '';
        if (startDateField) startDateField.value = data.start_date || '';
        if (endDateField) endDateField.value = data.end_date || '';
        if (totalCostField) totalCostField.value = data.total_cost || '';
  
        // Set the form action dynamically
        if (form) {
          form.action = `/businesses/${data.business_id}/projects/${data.project_id}/tasks/${data.task_id}/sub_tasks/${data.sub_task_id}/activities/${activityId}/real_activities`;
  
          // Add CSRF token to the form
          const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
          const csrfInput = document.createElement("input");
          csrfInput.setAttribute("type", "hidden");
          csrfInput.setAttribute("name", "authenticity_token");
          csrfInput.setAttribute("value", csrfToken);
          form.appendChild(csrfInput);
        }
      })
      .catch(error => console.error("Error loading resource details:", error));
  }

}