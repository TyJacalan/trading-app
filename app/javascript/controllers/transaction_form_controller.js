import { Controller } from "@hotwired/stimulus"

export default class TransactionForm extends Controller {

    connect() {}

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
        const currencyField = this.element.querySelector("[name='transaction[currency]']")
        const symbolValue = selectedItem.dataset.value
        const priceValue = '100'
        const currencyValue = 'USD'
        
        symbolField.value = symbolValue
        priceField.value = priceValue
        currencyField.value = currencyValue
    }


}