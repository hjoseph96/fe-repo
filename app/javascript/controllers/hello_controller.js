import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("WTF");
    
    this.element.textContent = "Hello World!"
  }
}
