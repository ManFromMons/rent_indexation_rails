import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["content"];
  static classes= ["toggle"];
  static values = {
    // setup values that we reference in our controller, passed in from our HTML
    initialActive: { type: Boolean, default:true },
  }

  connect() {
    if (this.initialActiveValue === true) {
      // use the initialActiveValue passed from data-toggle-initial-active-value to optionally toggle our class
      this.toggle()
    }
  }

  toggle() {
    this.toggleClasses.map((c) => this.contentTarget.classList.toggle(c));
  }
}
