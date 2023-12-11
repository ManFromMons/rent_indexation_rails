import { Controller } from "@hotwired/stimulus"
import IMask from 'imask';

// Connects to data-controller="currency"
export default class extends Controller {
  static values = {pattern: String};
  static targets = ["source", "selector", "symbol"];


  connect() {
    this.mask = IMask(this.sourceTarget, {
      mask: Number,
      thousandsSeparator: ' '
    });
    this.updateSymbol('EUR')
  }

  initialize() {
  }

  disconnect() {
    this.mask?.destroy();
  }
  updateSymbol(currencyValue) {
    let newSymbol = "€";

    switch(currencyValue) {
      case "USD": newSymbol = "$"; break;
      case "GBP": newSymbol = "£"; break;
    }
    this.symbolTarget.textContent = newSymbol;

  }
  updatesymbol(){
    const sourceElement = this.selectorTarget;
    const currency = sourceElement.value ;

    this.updateSymbol(currency);
  }
}
