import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    // Dodajemo listener za otvaranje modala
    document.querySelectorAll('.open-modal').forEach(link => {
      link.addEventListener('click', this.handleModalClick.bind(this));
    });
  }

  handleModalClick(event) {
    const activityId_from_button = event.target.dataset.activityId;
    const activityId = document.querySelector("[name='activity[activity_id]']").value = activityId_from_button;
    const form = this.element.querySelector("form");
    const submitButton = form.querySelector("input[type='submit']");
    const mode = event.target.dataset.mode; // Pretpostavljamo da modal ima atribut `data-mode`
    
    if (activityId) {
      submitButton.value = t("actions.edit.resource");
    } else {
      submitButton.value = t("table.new.resource");
    }
    
    // Ako je mode 'show', postavi sve inpute na readonly i sakrij submit dugme
    if (mode === 'show') {
      this.setFormReadOnly(form);  // Postavi polja na readonly i disable
      this.hideSubmitButton(submitButton);  // Sakrij submit dugme
    } else  {
      this.setFormEditable(form);  // Ukloni readonly i disable
      this.showSubmitButton(submitButton);  // Prikazivanje submit dugmeta
    }
  }
  
  setFormReadOnly(form) {
    const formFields = form.querySelectorAll('input, select, textarea');
    formFields.forEach(field => {
      field.setAttribute("readonly", true);
      field.disabled = true;
    });
  }
  
  setFormEditable(form) {
    const formFields = form.querySelectorAll('input, select, textarea');
    formFields.forEach(field => {
      field.removeAttribute("readonly");  // Uklanja readonly
      field.disabled = false;  // Omogućava interakciju sa poljem
    });
  }
  
  hideSubmitButton(submitButton) {
    submitButton.style.display = 'none';  // Sakrij dugme
  }
  
  showSubmitButton(submitButton) {
    submitButton.style.display = 'inline-block';  // Prikazivanje dugmeta
  }
  
  

  setFormReadOnly(form) {
    const formFields = form.querySelectorAll('input, select, textarea'); // Svi inputi, select i textarea u formi
    formFields.forEach(field => {
      field.setAttribute("readonly", true);  // Postavi readonly
      field.disabled = true; // Takođe onemogući interakciju sa poljem
    });
  }
    
  
  

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
        const placeholderOption = document.createElement("option");
        placeholderOption.value = "";
        placeholderOption.textContent = "-- Odaberite resurs --";
        placeholderOption.selected = true;
        placeholderOption.disabled = true;
        resourceSelect.appendChild(placeholderOption);

        // Dodaj resurse
        data.forEach(resource => {
          const option = document.createElement("option");
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
    const startDate = document.querySelector("[name='activity[start_date]']");
    const endDate = document.querySelector("[name='activity[end_date]']");

    if (quantityField) quantityField.value = '';
    if (totalField) totalField.value = '';
    if (unitOfMeasureField) unitOfMeasureField.value = '';
    if (pricePerUnitField) pricePerUnitField.value = '';
    if (descriptionField) descriptionField.value = '';
    if (professionField) professionField.value = '';
    if (fixedCostsField) fixedCostsField.value = '';
    if (startDate) startDate.value = '';
    if (endDate) endDate.value = '';
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
