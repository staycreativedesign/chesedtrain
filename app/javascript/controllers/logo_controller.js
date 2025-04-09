import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="logo"
export default class extends Controller {
  static targets = ["image"]
  connect() {
    requestAnimationFrame(() => {
      const image = this.imageTarget
      image.style.right = "0" // Remove right alignment

      // Center the logo horizontally
      image.style.transform = "translateX(-50%)"
      image.style.right = "auto" // Remove right alignment
      image.style.opacity = "1"
    })
  }
}
