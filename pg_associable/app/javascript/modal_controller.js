import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']

  modalPuntero = null

  connect (e) {
    this.modalPuntero = new bootstrap.Modal(this.element)
    if (this.element.dataset.removeOnHide) {
      this.element.addEventListener('hidden.bs.modal', (e) => {
        this.element.remove()
      })
    }
    this.modalPuntero.show()

    this.element.addEventListener('pg:record-created', (ev) => {
      const el = ev.data
      if (this.asociableOutlets.length > 0) {
        const newObject = JSON.parse(el.dataset.response)
        this.asociableOutlet.completarCampo(newObject)
        ev.stopPropagation()
      }
      this.modalPuntero.hide()
    })

    this.element.addEventListener('pg:record-updated', (ev) => {
      this.modalPuntero.hide()
    })

    this.element.addEventListener('pg:record-destroyed', (ev) => {
      this.modalPuntero.hide()
    })

    document.addEventListener('turbo:before-cache', () => {
      this.element.remove()
    }, { once: true })
  }

  openModal () {
    this.modalPuntero.show()
  }

  disconnect (e) {
    this.modalPuntero.hide()
    document.dispatchEvent(new Event('hidden.bs.modal'))
    this.modalPuntero.dispose()
  }
}
