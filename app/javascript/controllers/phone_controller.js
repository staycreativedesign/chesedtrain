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
    // Get the current cursor position
    const cursorPosition = this.inputTarget.selectionStart;

    // Remove all non-numeric characters except for '+'
    let input = this.inputTarget.value.replace(/[^+\d]/g, "");

    // If the input doesn't start with a '+' symbol, ensure it defaults to the U.S. country code '+1'
    if (input.length > 0 && !input.startsWith("+")) {
      input = "+1" + input.slice(1);  // Prepend '+1' if the user didn't input a country code
    }

    // Limit input length to prevent excessive characters
    if (input.length > 16) { // Allows for up to 15 digits + 1 '+' symbol
      input = input.substring(0, 16);
    }

    // Formatting logic for international numbers with 2-digit country codes
    let formattedValue = "";
    if (input.startsWith("+")) {
      if (input.length <= 3) {
        // Only country code entered (2 digits + '+')
        formattedValue = input;
      } else {
        // Full number formatting without spaces or dashes
        formattedValue = input.slice(0, 3) + input.slice(3);
      }
    } else {
      // Default to U.S. format if no '+' detected (although this should be rare)
      formattedValue = `+${input.slice(1)}`;
    }

    // Update the input field value
    this.inputTarget.value = formattedValue;

    // Adjust the cursor position for backspacing
    const adjustment = formattedValue.length - input.length;
    this.inputTarget.setSelectionRange(cursorPosition + adjustment, cursorPosition + adjustment);
  }

}

