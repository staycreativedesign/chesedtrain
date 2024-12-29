import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "submit"];

  connect() {
    this.toggleButton()
  }

  toggleButton() {
    if (this.checkboxTarget.checked) {
      this.submitTarget.removeAttribute("disabled");
      this.submitTarget.classList.remove("cursor-not-allowed", "opacity-50");
    } else {
      this.submitTarget.setAttribute("disabled", "true");
      this.submitTarget.classList.add("cursor-not-allowed", "opacity-50");
    }
  }
}

