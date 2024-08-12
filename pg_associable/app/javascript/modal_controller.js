import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']
  static targets = ['response']

  modalPuntero = null

  connect (e) {
    this.modalPuntero = new bootstrap.Modal(this.element)
    if (this.element.dataset.removeOnHide) {
      this.element.addEventListener('hidden.bs.modal', (e) => {
        this.element.remove()
      })
    }
    this.modalPuntero.show()
    document.addEventListener('turbo:before-cache', () => {
      this.element.remove()
    }, { once: true })
  }

  responseTargetConnected (e) {
    const newObject = JSON.parse(e.dataset.response)
    this.asociableOutlet.completarCampo(newObject)
    this.element.remove()
  }

  openModal () {
    this.modalPuntero.show()
  }

  disconnect (e) {
    this.modalPuntero.hide()
    this.element.dispatchEvent(new Event('hidden.bs.modal'))
    this.modalPuntero.dispose()
  }
}
