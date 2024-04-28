import { Controller } from "@hotwired/stimulus";
 export default class ToggleFrame extends Controller {
    static targets = ["frame", "detail"]

    connect() {}

    toggleFrame() {
        this.frameTarget.toggleAttribute("hidden")
        this.detailTarget.toggleAttribute("hidden")
    }
 }