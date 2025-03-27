import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="link-click"
export default class extends Controller {
  static values = { url: String, redirect: String }

  connect() {
    console.log("foo")
  }


  click(event) {
    event.preventDefault()

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      }
    }).then(() => {
        const url = this.redirectValue.startsWith("http") 
          ? this.redirectValue 
          : `https://${this.redirectValue}`
        window.open(url, "_blank")
      }).catch(error => {
        console.error("Tracking failed:", error)
        const url = this.redirectValue.startsWith("http") 
          ? this.redirectValue 
          : `https://${this.redirectValue}`
        window.open(url, "_blank")
      })
  }

}
