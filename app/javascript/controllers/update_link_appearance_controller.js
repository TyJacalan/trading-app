import { Controller } from "@hotwired/stimulus";

export default class UpdateLinkAppearance extends Controller {

    connect() {
      this.element.addEventListener("click", () => {

        const links = document.querySelectorAll(`[data-controller="${this.element.dataset.controller}"]`)
        links.forEach(link => link.classList.remove("bg-green-100"))
        
        this.element.classList.add("bg-green-100")
      })
    }

}