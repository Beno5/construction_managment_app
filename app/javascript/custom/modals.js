document.addEventListener("turbo:load", function () {
    console.log("JavaScript loaded and running."); // Debug log za potvrdu učitavanja

    // Delegacija za zatvaranje modala
    document.addEventListener("click", function (event) {
        if (event.target.classList.contains("close-modal")) {
            const modal = event.target.closest(".modal");
            if (modal) {
                modal.classList.add("hidden");
                console.log(`Modal ${modal.id} zatvoren.`); // Debug log
            }
        }
    });

    // Delegacija za otvaranje modala
    document.addEventListener("click", function (event) {
        if (event.target.classList.contains("open-modal")) {
            const targetId = event.target.dataset.target;
            const modal = document.getElementById(targetId);
            if (modal) {
                modal.classList.remove("hidden");
                console.log(`Modal ${modal.id} otvoren.`); // Debug log
            } else {
                console.error(`Modal sa ID-jem ${targetId} nije pronađen.`); // Debug za grešku
            }
        }
    });
});
