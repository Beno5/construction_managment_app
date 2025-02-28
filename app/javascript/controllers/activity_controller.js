import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  updateQuantity(event) {
    const quantity = parseFloat(event.target.value) || 0; // Uzimamo količinu
    const pricePerUnitField = document.querySelector("[name='activity[price_per_unit]']");
    const totalField = document.querySelector("[name='activity[total_cost]']"); // Uzmemo total input po ID-ju
  
    const pricePerUnit = parseFloat(pricePerUnitField.value) || 0; // Uzimamo cenu po jedinici
    const total = quantity * pricePerUnit; // Izračunavamo ukupno

    totalField.value = total.toFixed(2); // Postavljamo ukupno u input
  }

  updateResources(event) {
    const category = event.target.value;
    const resourceSelect = document.getElementById("activity_resource");
    const businessId = resourceSelect.dataset.businessId;
    
    this.clearFields(); // Očisti polja prilikom promjene kategorije

    this.hideAdditionalFields(); // Sakrij sve dodatne informacije

    if (!category || !businessId) return;

    fetch(`/fetch_data/resources?category=${category}&business_id=${businessId}`)
      .then(response => response.json())
      .then(data => {
        resourceSelect.innerHTML = "";

        // Dodaj placeholder opciju
        let placeholderOption = document.createElement("option");
        placeholderOption.value = "";
        placeholderOption.textContent = "-- Odaberite resurs --";
        placeholderOption.selected = true;
        placeholderOption.disabled = true;
        resourceSelect.appendChild(placeholderOption);

        // Dodaj resurse
        data.forEach(resource => {
          let option = document.createElement("option");
          option.value = resource.id;
          option.textContent = resource.name;
          resourceSelect.appendChild(option);
        });

        // Prikaz dodatnih informacija na osnovu kategorije
        this.showAdditionalFields(category);
      })
      .catch(error => console.error("Error loading resources:", error));
  }


  hideAdditionalFields() {
    const fixedCostsField = document.querySelector("[name='activity[fixed_costs]']").closest('.mb-4');
    const professionField = document.querySelector("[name='activity[profession]']").closest('.mb-4');

    if (fixedCostsField) fixedCostsField.classList.add('hidden');
    if (professionField) professionField.classList.add('hidden');
  }

  clearFields() {
    const unitOfMeasureField = document.querySelector("[name='activity[unit_of_measure]']");
    const pricePerUnitField = document.querySelector("[name='activity[price_per_unit]']");
    const descriptionField = document.querySelector("[name='activity[description]']");
    const professionField = document.querySelector("[name='activity[profession]']");
    const fixedCostsField = document.querySelector("[name='activity[fixed_costs]']");
    const quantityField = document.querySelector("[name='activity[quantity]']");
    const totalField = document.querySelector("[name='activity[total_cost]']");

    if (quantityField) quantityField.value = '';
    if (totalField) totalField.value = '';
    if (unitOfMeasureField) unitOfMeasureField.value = '';
    if (pricePerUnitField) pricePerUnitField.value = '';
    if (descriptionField) descriptionField.value = '';
    if (professionField) professionField.value = '';
    if (fixedCostsField) fixedCostsField.value = '';
  }

  showAdditionalFields(category) {
    const fixedCostsField = document.querySelector("[name='activity[fixed_costs]']").closest('.mb-4');
    const professionField = document.querySelector("[name='activity[profession]']").closest('.mb-4');

    if (category === 'worker' && professionField) {
      professionField.classList.remove('hidden');
    } else if (category === 'machine' && fixedCostsField) {
      fixedCostsField.classList.remove('hidden');
    }
  }

  updateReadOnlyFields(event) {
    const resourceId = event.target.value;
    const categorySelect = document.getElementById("activity_category");
    const category = categorySelect.value;

    if (!resourceId || !category) return;

    const quantityField = document.querySelector("[name='activity[quantity]']");
    const totalField = document.querySelector("[name='activity[total_cost]']");
    if (quantityField) quantityField.value = '';
    if (totalField) totalField.value = '';

    fetch(`/fetch_data/resource_details?id=${resourceId}&category=${category}`)
      .then(response => response.json())
      .then(data => {
        const unitOfMeasureField = document.querySelector("[name='activity[unit_of_measure]']");
        const pricePerUnitField = document.querySelector("[name='activity[price_per_unit]']");
        const descriptionField = document.querySelector("[name='activity[description]']");

        // Popuni read-only polja
        if (unitOfMeasureField) unitOfMeasureField.value = data.unit_of_measure || '';
        if (pricePerUnitField) pricePerUnitField.value = data.price_per_unit || '';
        if (descriptionField) descriptionField.value = data.description || '';

        // Ako je worker, popuni profesiju
        if (data.profession && this.isWorkerSelected()) {
          const professionField = document.querySelector("[name='activity[profession]']");
          if (professionField) professionField.value = data.profession;
        }

        // Ako je machine, popuni fiksne troškove
        if (data.fixed_costs && this.isMachineSelected()) {
          const fixedCostsField = document.querySelector("[name='activity[fixed_costs]']");
          if (fixedCostsField) fixedCostsField.value = data.fixed_costs;
        }
      })
      .catch(error => console.error("Error loading resource details:", error));
  }

  isWorkerSelected() {
    const categorySelect = document.getElementById("activity_category");
    return categorySelect.value === 'worker';
  }

  isMachineSelected() {
    const categorySelect = document.getElementById("activity_category");
    return categorySelect.value === 'machine';
  }
}
