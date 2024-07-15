import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']
  static targets = ['response']

  modalPuntero = null

  connect (e) {
    const form = this.element.querySelector('form')
    if (form) {
      form.addEventListener("turbo:submit-end", (e) => {
        // Vuelvo a disablear el botón de submit, por las dudas
        e.detail.formSubmission.submitter.setAttribute("disabled", "");
      })

      form.addEventListener("turbo:before-fetch-response", async (e) => {
        if (e.detail.fetchResponse.response.headers.get('content-type').includes('json')) {
          // debugger
          e.preventDefault()
          e.stopPropagation()
          let response = await e.detail.fetchResponse.responseText
          let json = JSON.parse(response)
          console.log(json)
        }
      })
    }

    this.modalPuntero = new bootstrap.Modal(this.element)
    if (this.element.dataset.removeOnHide) {
      this.element.addEventListener('hidden.bs.modal', (e) => {
        this.element.remove()
        window.Stimulus.controllers.map((c) => { return c.calendar })
          .filter((e) => { return e })
          .map((c) => { c.refetchEvents() })
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
    this.modalPuntero.dispose()
  }
}
