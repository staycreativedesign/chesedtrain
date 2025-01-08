import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["notification"]

  showNotification(e) {
    e.preventDefault()

    this.notificationTarget.classList.remove("hidden")
    setTimeout(() => {
      this.notificationTarget.classList.add("hidden")
    }, 3000)

  }
}
