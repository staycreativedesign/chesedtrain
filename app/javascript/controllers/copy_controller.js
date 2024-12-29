import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }
  copyUrl(event) {
    // Prevent the default link behavior (navigation)
    event.preventDefault();

    const eventURL = window.location.href;  // Get the current URL (or replace with your event URL)
    const tempInput = document.createElement('input');
    tempInput.value = eventURL;
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand('copy');  // Copy the content to clipboard
    document.body.removeChild(tempInput);

    // Optionally: provide user feedback
    alert('Event information copied!');
  }
}

