import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    console.log("Stimulus modal controller connected.");
  }

  open(event) {
    event.preventDefault();
    const button = event.currentTarget;
    
    // Proveri da li modal postoji
    if (!this.hasModalTarget) {
      console.error("Modal target nije pronađen!");
      return;
    }

    const modal = this.modalTarget;

    // Preuzimanje podataka iz data atributa
    const mode = button.dataset.mode || "default";
    const id = button.dataset.id || "N/A";
    
    console.log("Modal otvoren u modu:", mode, "sa ID:", id);

    // Prikazivanje modala
    modal.classList.remove("hidden");
  }

  close() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden");
    }
  }
}
