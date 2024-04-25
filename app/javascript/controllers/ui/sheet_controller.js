import UIDialog from "./dialog_controller";
import "@kanety/stimulus-static-actions";

export default class extends UIDialog {
  connect(){}

  toggleOutlet() {
    const sheetTarget = document.querySelector(this.element.dataset.UiSheetOutlet);
    const dialogTarget = sheetTarget.querySelector("[data-ui--sheet-target='dialog']");
    const modalTarget = sheetTarget.querySelector("[data-ui--sheet-target='modal']");
    const contentTarget = sheetTarget.querySelector("[data-ui--sheet-target='content']");
    const visible = dialogTarget.dataset.state == "closed" ? false : true;

    if (!visible) {
      document.body.classList.add("overflow-hidden");
      contentTarget.classList.add("overflow-y-scroll", "h-full");
      dialogTarget.classList.remove("hidden");
      dialogTarget.dataset.state = "open";
      modalTarget.classList.remove("hidden");
      modalTarget.dataset.state = "open";
    } else {
      document.body.classList.remove("overflow-hidden");
      contentTarget.classList.remove("overflow-y-scroll", "h-full");
      dialogTarget.classList.add("hidden");
      dialogTarget.dataset.state = "closed";
      modalTarget.classList.add("hidden");
      modalTarget.dataset.state = "closed";
    }
  }
}
