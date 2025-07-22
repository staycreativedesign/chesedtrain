import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

  toggle(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const infoElement = button.closest('.lg\\:grid').nextElementSibling;

    if (infoElement?.classList?.contains("yom-tov-info")) {
      infoElement.classList.toggle("hidden");
    }
  }
}
