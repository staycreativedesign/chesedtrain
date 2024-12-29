import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("foo")
  }

  restrictInput(event) {
    // Allow only numbers, dashes, parentheses, spaces, and the country code prefix '+'
    const validChars = /^[0-9\s\-\(\)\+]*$/;
    if (!validChars.test(event.target.value)) {
      event.target.value = event.target.value.replace(/[^0-9\s\-\(\)\+]/g, "");
    }
  }

  format() {
    // Remove all non-numeric characters except for '+'
    let input = this.inputTarget.value.replace(/\D/g, "");

    // Ensure that input starts with country code '1'
    if (input.length > 10) input = input.substring(0, 10); // Limit to 10 digits (U.S. phone numbers)
    
    // Apply proper formatting: +1 (XXX) XXX-XXXX
    if (input.length <= 3) {
      this.inputTarget.value = `1(${input}`;
    } else if (input.length <= 6) {
      this.inputTarget.value = `1(${input.slice(0, 3)}) ${input.slice(3)}`;
    } else {
      this.inputTarget.value = `1(${input.slice(0, 3)}) ${input.slice(3, 6)}-${input.slice(6, 10)}`;
    }
  }

}

