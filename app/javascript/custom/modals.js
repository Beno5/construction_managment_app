document.addEventListener("turbo:load", function () {
    // Close modal
    document.querySelectorAll(".close-modal").forEach((button) => {
      button.addEventListener("click", function () {
        const modal = this.closest(".modal");
        modal.classList.add("hidden");
      });
    });
  
    // Open modal
    document.querySelectorAll(".open-modal").forEach((button) => {
      button.addEventListener("click", function () {
        const targetId = this.dataset.target;
        const modal = document.getElementById(targetId);
        if (modal) {
          modal.classList.remove("hidden");
        }
      });
    });
  });
  