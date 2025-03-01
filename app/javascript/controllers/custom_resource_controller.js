import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["quantity", "pricePerUnit", "total"];

  updateQuantity(event) {
    const quantity = parseFloat(this.quantityTarget.value) || 0; // Uzimamo količinu
    const pricePerUnit = parseFloat(this.pricePerUnitTarget.value) || 0; // Uzimamo cenu po jedinici
    const total = quantity * pricePerUnit; // Izračunavamo ukupno

    this.totalTarget.value = total.toFixed(2); // Postavljamo ukupno u input
  }

  updateResources(event) {
    const category = event.target.value;
    
    this.clearFields(); // Očisti prethodna polja
    this.hideAdditionalFields(); // Sakrij dodatne informacije

    if (category === 'worker') {
      this.showWorkerFields(); // Ako je odabran Worker, prikaži First Name i Last Name
    } else {
      this.showNameField(); // Ako nije Worker, prikaži Name
    }

    // Ovdje možeš dodati ostalu logiku za različite kategorije
  }

  clearFields() {
    const nameField = document.querySelector("[name='custom_resource[name]']");
    if (nameField) nameField.value = ''; // Očisti naziv polja
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
