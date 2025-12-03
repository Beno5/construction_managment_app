import { Controller } from "@hotwired/stimulus";
import { initFlowbite } from "flowbite";

export default class extends Controller {
  connect() {
    // Reinitialize Flowbite components when this element appears (e.g., after Turbo stream updates)
    initFlowbite();
  }
}
