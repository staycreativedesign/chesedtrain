import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "progressBar"];
  static values = { url: String };

  now() {
    Array.from(this.inputTarget.files).forEach(file => this._uploadFile(file));
    this.inputTargets.forEach(input => input.value = null);
  }

  _uploadFile(file) {
    debugger
    new DirectUpload(
      file,
      this.urlValue,
      this // callback directUploadWillStoreFileWithXHR(request)
    ).create((error, blob) => {
      if (error) {
        console.log(error);
      } else {
        this._createHiddenInput(blob);
      }
    });
  }

  _createHiddenInput(blob) {
    const hiddenField = document.createElement("input");

    hiddenField.setAttribute("id", `attachment_${blob.filename}`);
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("value", blob.signed_id);
    hiddenField.name = this.element.name;

    this.element.appendChild(hiddenField);
  }

  directUploadWillStoreFileWithXHR(request) {
    debugger
    request.upload.addEventListener("progress", (event) => {
      this._progressUpdate(event);
    });
  }

  _progressUpdate(event) {
    debugger
    const progress = (event.loaded / event.total) * 100;

    this.progressBarTargets.forEach((progressBar) => {
      progressBar.style.width = `${progress}%`;
    });
  }
}
