import { Controller } from "@hotwired/stimulus";
import confetti from "canvas-confetti";

export default class extends Controller {
  connect() {
    this.fireConfetti();
    if (document.referrer.includes("steps")) {
      this.fireConfetti();
    }
  }

  fireConfetti() {
    confetti({
      particleCount: 200,
      spread: 120,
      angle: 90,
      origin: { y: 0.6 },
    });
  }
}
