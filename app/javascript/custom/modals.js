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
