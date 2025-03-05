document.addEventListener("turbo:load", function () {
  console.log("JavaScript loaded and running.");

  document.querySelectorAll(".close-modal").forEach((button) => {
    button.addEventListener("click", function () {
      const modal = this.closest(".modal");
      if (modal) {
        modal.classList.add("hidden");
  
        // Selektovanje svih formi unutar modala
        const forms = modal.querySelectorAll("form");

        const fileNameSpan = modal.querySelector("#file-name");
        if (fileNameSpan) {
          fileNameSpan.textContent = "No file selected"; // Reset the file name display
        }
  
        // Resetovanje formi
        forms.forEach((form) => {
          form.querySelectorAll("input:not([type='submit']), select, textarea").forEach((field) => {
            if (field.type === "checkbox" || field.type === "radio") {
              field.checked = false; // Resetovanje checkbox-a i radio dugmadi
            } else {
              field.value = ""; // Resetovanje input-a i text area-a
            }
          });
        });
  
        // Resetovanje toggle stanja
        const toggle = document.getElementById("resource-toggle");
        if (toggle) {
          toggle.checked = false; // Resetovanje na početno stanje
          toggleColor(); // Pozivanje funkcije za resetovanje boje teksta
        }
  
        console.log(`Modal with ID '${modal.id}' is now hidden and form is reset.`);
      }
    });
  });
  
  // Funkcija za mijenjanje boje teksta ovisno o stanju toggle-a
  function toggleColor() {
    const checkbox = document.getElementById('resource-toggle');
    const standardText = document.getElementById('standard-text');
    const customText = document.getElementById('custom-text');
  
    if (checkbox.checked) {
      standardText.classList.remove('text-blue-600');
      standardText.classList.add('text-gray-900');
      customText.classList.remove('text-gray-900');
      customText.classList.add('text-blue-600');
    } else {
      customText.classList.remove('text-blue-600');
      customText.classList.add('text-gray-900');
      standardText.classList.remove('text-gray-900');
      standardText.classList.add('text-blue-600');
    }
  }
  
  // Pozivaj funkciju na učitavanje stranice kako bi se postavio početni status
  document.addEventListener('DOMContentLoaded', () => {
    toggleColor();
  });
  
  
  
  
  

  // Open modal
  document.querySelectorAll(".open-modal").forEach((button) => {
    button.addEventListener("click", function () {
      const targetId = this.dataset.target; // Use dataset.target for modal ID
      const modal = document.getElementById(targetId);
      if (modal) {
        modal.classList.remove("hidden");
        console.log(`Modal with ID '${targetId}' is now visible.`);
      } else {
        console.error(`Modal with ID '${targetId}' not found.`);
      }
    });
  });
});


document.addEventListener("turbo:load", function () {
  const categorySelect = document.getElementById("custom_resource_category");
  const unitSelect = document.getElementById("custom_resource_unit_of_measure");

  if (!categorySelect || !unitSelect) return;

  fetch('/fetch_data/unit_options')
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(unitOptions => {
      categorySelect.addEventListener("change", function () {
        const selectedCategory = categorySelect.value;
        const units = unitOptions[selectedCategory] || {};

        unitSelect.innerHTML = '<option value="">Select Unit</option>';

        Object.entries(units).forEach(([key, label]) => {
          const option = document.createElement("option");
          option.value = key;
          option.textContent = label;
          unitSelect.appendChild(option);
        });
      });
    })
    .catch(error => console.error('Error fetching unit options:', error));
});
