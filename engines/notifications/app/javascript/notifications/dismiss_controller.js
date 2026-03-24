import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notifications--dismiss"
export default class extends Controller {
  static targets = ["item"]
  static values = { url: String }

  dismiss() {
    this.element.classList.add("dismissing")

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']")?.content,
        "Accept": "application/json"
      }
    }).then(response => {
      if (response.ok) {
        this.element.remove()
      } else {
        this.element.classList.remove("dismissing")
      }
    })
  }
}
