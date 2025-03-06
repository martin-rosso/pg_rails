import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="bulk-edit-field-activator"
export default class extends Controller {
  connect () {
    this.element.addEventListener('change', function(ev) {
      ev.target.closest('form').querySelector('button[name=refresh]').click()
    })
  }
}
