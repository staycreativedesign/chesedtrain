import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  connect() {
    this.fadeInAndOut();
  }

  fadeInAndOut() {
    const element = this.contentTarget;

    setTimeout(() => {
      element.classList.remove("opacity-0");
      element.classList.add("opacity-100");
    }, 100);

    // Wait 4 seconds, then fade out
    setTimeout(() => {
      element.classList.remove("opacity-100");
      element.classList.add("opacity-0");

      // Wait for the transition to complete before removing
      element.addEventListener("transitionend", () => {
        element.remove();
      }, { once: true });
    }, 2000);
  }
}
