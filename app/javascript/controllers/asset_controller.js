import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="asset"
export default class extends Controller {
  initialize() {
    console.log("WTF");
  }

  connect() {
    this.element.textContent = "Hello World!"
  }
}
