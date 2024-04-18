import { Controller } from "@hotwired/stimulus";

export default class UpdateLinkAppearance extends Controller {

    connect() {
      this.element.addEventListener("click", () => {

        const links = document.querySelectorAll(`[data-controller="${this.element.dataset.controller}"]`)
        links.forEach(link => link.classList.remove("bg-accent"))

        this.element.classList.add("bg-accent")
      })
    }

}
