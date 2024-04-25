import { Controller } from "@hotwired/stimulus";

export default class UIFilter extends Controller {
  static targets = ["source", "items", "item"];

  connect() {}

  showItems() {
    this.itemsTarget.classList.remove("hidden")
  }

  hideItems() {
    this.itemsTarget.classList.add("hidden")
  }

  selectItem(event){
    const selectedItem = event.currentTarget
    const itemValue = selectedItem.dataset.value

    this.sourceTarget.value = selectedItem.textContent
    this.sourceTarget.dataset.value = itemValue

    this.itemsTarget.classList.add("hidden")
  }

  filter() {

    clearTimeout(this.filterTimeout)

    this.filterTimeout = setTimeout(() => {
      let lowerCaseFilterTerm = this.sourceTarget.value.toLowerCase();
      let regex = new RegExp("^" + lowerCaseFilterTerm);
  
      if (this.hasItemTarget) {
        this.itemTargets.forEach((el) => {
          let filterableKey = el.innerText.toLowerCase();
  
          el.classList.toggle("hidden", !regex.test(filterableKey));
        });
      }
    }, 300)
  }
}
