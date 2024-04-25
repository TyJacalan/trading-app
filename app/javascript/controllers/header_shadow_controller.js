import { Controller } from "@hotwired/stimulus";

export default class HeaderShadow extends Controller {
    connect() {
        this.toggleHeaderShadow = this.toggleHeaderShadow.bind(this); // Bind the method to the class instance
        this.toggleHeaderShadow(); // Call the method once to initialize the shadow
        window.addEventListener("scroll", this.toggleHeaderShadow);
    }

    disconnect() {
        window.removeEventListener("scroll", this.toggleHeaderShadow);
    }

    toggleHeaderShadow() {
        const header = this.element;
        if (window.scrollY > 0) {
            header.classList.add("shadow-lg");
        } else {
            header.classList.remove("shadow-lg");
        }
    }
}
