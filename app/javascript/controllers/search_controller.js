import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Prevent ENTER key from submitting the form
    this.element.addEventListener("keydown", this.preventEnterSubmit.bind(this));

    // Auto-restore search results when navigating back
    // Use double requestAnimationFrame to ensure Turbo Frames are fully loaded
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.restoreSearchOnPageLoad();
      });
    });
  }

  disconnect() {
    // Clean up event listener when controller is disconnected
    this.element.removeEventListener("keydown", this.preventEnterSubmit.bind(this));
  }

  preventEnterSubmit(event) {
    // If ENTER key is pressed inside the search form, prevent default submission
    if (event.key === "Enter" || event.keyCode === 13) {
      event.preventDefault();
      event.stopPropagation();
      return false;
    }
  }

  performSearch(event) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      // The controller is attached to the form element itself
      const form = this.element.tagName === "FORM" ? this.element : this.element.closest("form");
      if (form) {
        form.requestSubmit();
      }
    }, 300); // Čeka 300ms pre slanja zahteva
  }

  restoreSearchOnPageLoad() {
    // The controller is attached to the form element itself
    const form = this.element.tagName === "FORM" ? this.element : this.element.closest("form");
    if (!form) return;

    const searchInput = form.querySelector('input[name="search"]');
    if (!searchInput) return;

    const searchValue = searchInput.value.trim();

    // Only restore if there's a search value
    if (!searchValue) return;

    // Check if URL already has the search param matching current input
    const urlParams = new URLSearchParams(window.location.search);
    const urlSearchParam = urlParams.get('search');

    // If input has value but URL doesn't match, we need to restore
    if (!urlSearchParam || urlSearchParam !== searchValue) {
      const turboFrameId = form.dataset.turboFrame;
      console.log(`[Search] Restoring search results for: "${searchValue}" (frame: ${turboFrameId || 'full page'})`);

      // For Turbo Frames, give extra time to ensure frame is ready
      const delay = turboFrameId ? 150 : 50;

      setTimeout(() => {
        form.requestSubmit();
      }, delay);
    }
  }
}
