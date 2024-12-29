import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";

export default class extends Controller {
  connect() {
    const picker = flatpickr(this.element, {
      mode: "range",
      dateFormat: "Y-m-d",
      inline: true,
    });
    picker.open();
  }
}

