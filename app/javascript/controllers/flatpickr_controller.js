import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";

export default class extends Controller {
  connect() {
    // Read options from data-flatpickr-options attribute
    const options = this.element.dataset.flatpickrOptions
      ? JSON.parse(this.element.dataset.flatpickrOptions)
      : {};

    // Initialize flatpickr with dynamic options
    const picker = flatpickr(this.element, options);

    picker.open();
  }
}
