import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  connect() {
    const logo = document.querySelector("#logo");
    document.addEventListener("DOMContentLoaded", function() {
    logo.style.marginLeft = "0";
    });
  }
}
