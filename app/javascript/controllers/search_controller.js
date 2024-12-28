import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  performSearch(event) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.closest("form").requestSubmit();
    }, 300); // Čeka 300ms pre slanja zahteva
  }
}
