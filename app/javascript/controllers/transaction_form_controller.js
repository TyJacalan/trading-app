import { Controller } from "@hotwired/stimulus"

export default class TransactionForm extends Controller {

    connect() {
        this.calculateTotal()

        this.submitButton = this.element.querySelector(".submit-button")
        this.spinner = this.element.querySelector(".spinner")
    }

    handleSubmit() {
        this.submitButton.classList.add("hidden")
        this.spinner.classList.remove("hidden")
    }

    calculateTotal() {
        const quantityInput = this.element.querySelector("[name='transaction[quantity]']")
        quantityInput.focus()

        quantityInput.addEventListener("input", this.updateTotal.bind(this))        
    }

    updateTotal() {
        const price = parseFloat(this.element.querySelector("[name='transaction[price]']").value) || 0
        const quantity = parseFloat(this.element.querySelector("[name='transaction[quantity]']").value) || 0
        const totalValue = this.element.querySelector("[name='total_value']")
        
        totalValue.value = (price * quantity).toFixed(2)
    }

    updateSymbol(event){
        const filterDiv = event.target.closest("[data-ui--filter-target='item']")
        if (!filterDiv) {
            console.error("Target not found.")
            return
        }
        const selectedItem = filterDiv.querySelector("div")
        if (!selectedItem) {
            console.error("Inner div not found")
            return
        }

        const symbolField = this.element.querySelector("[name='transaction[symbol]']")
        const priceField = this.element.querySelector("[name='transaction[price]']")
        const symbolValue = selectedItem.dataset.value
        const priceValue = '100'
        
        symbolField.value = symbolValue
        priceField.value = priceValue
    }


}