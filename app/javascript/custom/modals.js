document.addEventListener("turbo:load", function () {
  console.log("JavaScript loaded and running.");

  // Close modal
  document.querySelectorAll(".close-modal").forEach((button) => {
    button.addEventListener("click", function () {
      const modal = this.closest(".modal");
      if (modal) {
        modal.classList.add("hidden");
        console.log(`Modal with ID '${modal.id}' is now hidden.`);
      }
    });
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
