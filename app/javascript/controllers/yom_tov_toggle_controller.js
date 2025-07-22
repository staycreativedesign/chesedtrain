import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

  toggle(event) {
    event.preventDefault(); // Prevents the page jump
    this.infoTarget.classList.toggle("hidden")
  }
}
