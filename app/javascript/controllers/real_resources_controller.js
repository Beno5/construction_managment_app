import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    // Dodajemo listener za otvaranje modala
    document.querySelectorAll('.open-modal').forEach(link => {
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



    const quantityField = document.querySelector("[name='activity[quantity]']");
    const totalField = document.querySelector("[name='activity[total_cost]']");
    if (quantityField) quantityField.value = '';
    if (totalField) totalField.value = '';

    fetch(`/fetch_data/get_activity_and_real_activity_infos/${activityId}/${realActivityId_from_button}`)
    .then(response => response.json())
      .then(data => {
        const nameField = document.querySelector("[name='real_activity[name]']");
        const unitOfMeasureField = document.querySelector("[name='real_activity[unit_of_measure]']");
        const pricePerUnitField = document.querySelector("[name='real_activity[price_per_unit]']");
        const quantityField = document.querySelector("[name='real_activity[quantity]']");

        // Popuni read-only polja
        if (nameField) nameField.value = data.name || '';
        if (pricePerUnitField) pricePerUnitField.value = data.price_per_unit || '';
        if (unitOfMeasureField) unitOfMeasureField.value = data.unit_of_measure || '';
        if (quantityField) quantityField.value = data.quantity || '';

     // Set the form action dynamically
     const form = this.element.querySelector("form");
     form.action = `/businesses/${data.business_id}/projects/${data.project_id}/tasks/${data.task_id}/sub_tasks/${data.sub_task_id}/activities/${activityId}/real_activities`;

     // Add CSRF token to the form
     const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
     const csrfInput = document.createElement("input");
     csrfInput.setAttribute("type", "hidden");
     csrfInput.setAttribute("name", "authenticity_token");
     csrfInput.setAttribute("value", csrfToken);
     form.appendChild(csrfInput);
   })

      .catch(error => console.error("Error loading resource details:", error));
  }

}