import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

    static targets = [
    "quantity",
    "pricePerUnit",
    "totalCost",
    "name",
    "firstName",
    "lastName",
    "profession",
    "unitOfMeasure",
    "description"
  ];


  connect() {
    // Osluškuj klikove na linkove koji otvaraju modal
    document.querySelectorAll('.open-modal').forEach(link => {
      link.addEventListener('click', this.handleModalClick.bind(this));
    });
  }
  
  handleModalClick(event) {
    event.preventDefault(); // Sprečavamo da se link prati
  
    const modal = document.getElementById('resource-modal'); // Pronađi modal
    const mode = event.target.dataset.mode; // Dohvati vrednost mode (show, edit, ili undefined)
    const type = event.target.dataset.type; // Dohvati vrednost mode (show, edit, ili undefined)
   
    // Ako je mode definisan i nije "create", uzimamo rowId
    let rowId = null;
    if (mode && mode !== "create") {
      rowId = event.target.closest('tr').id.split('_')[1]; // Dohvati ID reda (npr. 53)
    }
    
    modal.dataset.mode = mode; // Postavi mode na modal
    
    this.initializeModal(mode, type); // Pokreni inicijalizaciju na osnovu moda

    // Ako imamo rowId, pozivamo fetchData da dohvatimo podatke
    if (rowId) {
      this.fetchData(rowId); // Dohvati podatke putem ID-a
    }
  }
  

  async fetchData(rowId) {
    try {
      const response = await fetch(`/fetch_data/${rowId}`, { method: 'GET' });
      const data = await response.json();
      console.log(data);
  
      // Pozivamo updateResources2 sa await, što znači da čekamo da se završi pre nego što pozovemo updateModal
      await this.updateResources2(data.activity_type);
      
      // Tek nakon što završi updateResources2, pozivamo updateModal
      this.updateModal(data);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }
  

  updateModal(data) {
    const modal = document.getElementById('resource-modal');
  
    // Check if the modal exists before continuing
    if (!modal) {
      console.error("Modal element not found!");
      return;
    }
  
    // Check the activity type to determine if it's a CustomResource
    if (data.activityable_type === "CustomResource") {

      if (data.activity_type === 'worker') {
        this.showWorkerFields(); // Show First Name and Last Name if category is 'worker'
      } else {
        this.showNameField(); // Show Name field if category isn't Worker or Custom Resource
      }

      // If it's a CustomResource, populate the fields for CustomResource
      const categoryField = modal.querySelector("#custom_resource_category");
      if (categoryField) categoryField.value = data.activity_type;
  
      const nameField = modal.querySelector("#custom_resource_name");
      if (nameField) nameField.value = data.resource_name;
  
      const firstNameField = modal.querySelector("#custom_resource_first_name");
      if (firstNameField) firstNameField.value = data.resoruce_first_name || '';
  
      const lastNameField = modal.querySelector("#custom_resource_last_name");
      if (lastNameField) lastNameField.value = data.resoruce_last_name || '';
  
      const professionField = modal.querySelector("#custom_resource_profession");
      if (professionField) professionField.value = data.resoruce_profession || '';
  
      const unitField = modal.querySelector("#custom_resource_unit_of_measure");
      if (unitField) unitField.value = data.resoruce_unit_of_measure;
  
      const quantityField = modal.querySelector("#custom_resource_quantity");
      if (quantityField) quantityField.value = data.quantity;
  
      const priceField = modal.querySelector("#custom_resource_price_per_unit");
      if (priceField) priceField.value = data.resoruce_price_per_unit;
  
      const descriptionField = modal.querySelector("#custom_resource_description");
      if (descriptionField) descriptionField.value = data.resoruce_description;
  
      const totalCostField = modal.querySelector("#custom_resource_total_cost");
      if (totalCostField) totalCostField.value = data.total_cost;
  
    } else {
      // If it's a different resource type, populate the fields accordingly
      const categoryField = modal.querySelector("#activity_category");
      if (categoryField) categoryField.value = data.activity_type;
  
      const resourceField = modal.querySelector("#activity_resource");
      if (resourceField) resourceField.value = data.activityable_id; // Link to the resource
  
      const quantityField = modal.querySelector("#activity_quantity");
      if (quantityField) quantityField.value = data.quantity;
  
      const unitField = modal.querySelector("#activity_unit_of_measure");
      if (unitField) unitField.value = data.resoruce_unit_of_measure;
  
      const priceField = modal.querySelector("#activity_price_per_unit");
      if (priceField) priceField.value = data.resoruce_price_per_unit;
  
      const descriptionField = modal.querySelector("#activity_description");
      if (descriptionField) descriptionField.value = data.resoruce_description;
  
      const professionField = modal.querySelector("#activity_profession");
      if (professionField) professionField.value = data.resoruce_profession || '';
  
      const totalCostField = modal.querySelector("#activity_total_cost");
      if (totalCostField) totalCostField.value = data.total_cost;
  
      const resourceNameField = modal.querySelector("#activity_resource_name");
      if (resourceNameField) resourceNameField.value = data.resource_name || '';
    }
  }
  

 
  async updateResources2(activity_type) {
    const category = activity_type;
    const resourceSelect = document.getElementById("activity_resource");
    const unitSelect = document.getElementById("custom_resource_unit_of_measure");
    const businessId = resourceSelect.dataset.businessId;

    this.hideAdditionalFields(); // Sakrij sve dodatne informacije

    if (!category || !businessId) return;

    try {
        // Dohvatanje resursa
        const resourceResponse = await fetch(`/fetch_data/resources?category=${category}&business_id=${businessId}`);
        const resourceData = await resourceResponse.json();

        // Dohvatanje opcija jedinica mere
        const unitResponse = await fetch('/fetch_data/unit_options');
        const unitOptions = await unitResponse.json();

        // Ispisivanje u konzolu kako bi proverio strukturu unitOptions
        console.log("unitOptions: ", unitOptions);

        // Očisti dropdown menije
        resourceSelect.innerHTML = "";
        unitSelect.innerHTML = "";

        // Dodaj placeholder opciju za resurse
        let placeholderOption = document.createElement("option");
        placeholderOption.value = "";
        placeholderOption.textContent = "-- Odaberite resurs --";
        placeholderOption.selected = true;
        placeholderOption.disabled = true;
        resourceSelect.appendChild(placeholderOption);

        // Dodaj resurse u dropdown
        resourceData.forEach(resource => {
            let option = document.createElement("option");
            option.value = resource.id;
            option.textContent = resource.name;
            resourceSelect.appendChild(option);
        });

        // Dodaj placeholder opciju za jedinice mere
        let unitPlaceholder = document.createElement("option");
        unitPlaceholder.value = "";
        unitPlaceholder.textContent = "-- Odaberite jedinicu --";
        unitPlaceholder.selected = true;
        unitPlaceholder.disabled = true;
        unitSelect.appendChild(unitPlaceholder);

        // Proveri koja kategorija je izabrana
        console.log("Selected Category: ", category);

        // Proveri strukturu unitOptions za selectedCategory
        const units = unitOptions[category] || {};
        console.log("Units for category: ", units); // Dodaj ispis da vidiš šta se nalazi

        Object.entries(units).forEach(([key, label]) => {
          let option = document.createElement("option");
          option.value = key;
          option.textContent = label;
          unitSelect.appendChild(option);

      });
      

    } catch (error) {
        console.error("Error fetching resources or unit options:", error);
    }
}






  
  
  
  initializeModal(mode, type) {
    const toggleContainer = document.getElementById('resource-toggle-container'); // Pronađi kontejner za toggle
    const formStandard = document.getElementById('standard-resources'); // Pronađi kontejner za toggle
    const customStandard = document.getElementById('custom-resources'); // Pronađi kontejner za toggle
  
    // Ako postoji 'mode' (tj. edit ili show), sakrij toggle
    if (mode === "edit" || mode === "show") {
      toggleContainer.classList.add('hidden');
    } else {
      // Ako nema mode (create), prikaži toggle
      toggleContainer.classList.remove('hidden');
    }

   if (type === "CustomResource") {
      customStandard.classList.remove('hidden');
      formStandard.classList.add('hidden');

      
   } else {
      formStandard.classList.remove('hidden');
      customStandard.classList.add('hidden');
   }

  }
  



  updateQuantity(event) {
    const quantity = parseFloat(this.quantityTarget.value) || 0; // Uzimamo količinu
    const pricePerUnit = parseFloat(this.pricePerUnitTarget.value) || 0; // Uzimamo cenu po jedinici
    const total = quantity * pricePerUnit; // Izračunavamo ukupno

    this.totalCostTarget.value = total.toFixed(2); // Postavljamo ukupno u input
  }

  updateResources(event) {
    const category = event.target.value || event.target.closest("form").querySelector("#activity_category").value;
    
    this.clearFields(); // Clear previous fields
    this.hideAdditionalFields(); // Hide additional fields by default
  
    // Show appropriate fields based on the selected category
    if (category === 'worker') {
      this.showWorkerFields(); // Show First Name and Last Name if category is 'worker'
    } else {
      this.showNameField(); // Show Name field if category isn't Worker or Custom Resource
    }
  
    // Add other category-specific logic if needed
  }
  
  clearFields() {
    const fields = [
        "custom_resource[quantity]",
        "custom_resource[price_per_unit]",
        "custom_resource[total_cost]",
        "custom_resource[name]",
        "custom_resource[first_name]",
        "custom_resource[last_name]",
        "custom_resource[profession]",
        "custom_resource[unit_of_measure]",
        "custom_resource[description]"
    ];

    fields.forEach(fieldName => {
        const field = document.querySelector(`[name='${fieldName}']`);
        if (field) field.value = ''; // Očisti polje ako postoji
    });
}


  hideAdditionalFields() {
    const nameField = document.querySelector("[name='custom_resource[name]']");
    const firstNameField = document.querySelector("[name='custom_resource[first_name]']");
    const lastNameField = document.querySelector("[name='custom_resource[last_name]']");
    const professionField = document.querySelector("[name='custom_resource[profession]']");

    // Sakrij naziv ako je Worker
    if (nameField) nameField.closest('.mb-4').classList.add('hidden');

    // Sakrij First Name i Last Name ako nisu Worker
    if (firstNameField) firstNameField.closest('.mb-4').classList.add('hidden');
    if (lastNameField) lastNameField.closest('.mb-4').classList.add('hidden');
    if (professionField) professionField.closest('.mb-4').classList.add('hidden');
  }

  showWorkerFields() {
    const firstNameField = document.querySelector("[name='custom_resource[first_name]']");
    const lastNameField = document.querySelector("[name='custom_resource[last_name]']");
    const professionField = document.querySelector("[name='custom_resource[profession]']");

    // Prikazivanje First Name i Last Name kada je Worker
    if (firstNameField) firstNameField.closest('.mb-4').classList.remove('hidden');
    if (lastNameField) lastNameField.closest('.mb-4').classList.remove('hidden');
    if (professionField) professionField.closest('.mb-4').classList.remove('hidden');
  }

  showNameField() {
    const nameField = document.querySelector("[name='custom_resource[name]']");
    if (nameField) nameField.closest('.mb-4').classList.remove('hidden'); // Prikazivanje naziva kad nije Worker
  }
}
