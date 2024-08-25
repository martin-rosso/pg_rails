import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']

  modalPuntero = null
  history = []

  connect (e) {
    this.modalPuntero = new bootstrap.Modal(this.element)
    if (this.element.dataset.removeOnHide) {
      this.element.addEventListener('hidden.bs.modal', (e) => {
        this.element.remove()
      })
    }
    this.modalPuntero.show()

    this.element.addEventListener('turbo:frame-render', (ev) => {
      if (ev.detail.fetchResponse.response.ok && ev.target.id === 'modal_content') {
        this.history.push(ev.target.src)
      }
    })

    this.element.addEventListener('pg:record-created', (ev) => {
      const el = ev.data
      if (this.asociableOutlets.length > 0) {
        const newObject = JSON.parse(el.dataset.response)
        this.asociableOutlet.completarCampo(newObject)
        ev.stopPropagation()
        this.remove()
      } else {
        this.back(ev)
      }
    })

    this.element.addEventListener('pg:record-updated', (ev) => {
      this.back(ev)
    })

    this.element.addEventListener('pg:record-destroyed', (ev) => {
      this.remove()
    })

    document.addEventListener('turbo:before-cache', () => {
      this.element.remove()
    }, { once: true })
  }

  maximize (ev) {
    const dialog = this.element.querySelector('.modal-dialog')
    dialog.classList.toggle('modal-fullscreen')
    const button = ev.currentTarget
    const icon = button.querySelector('i')
    icon.classList.toggle('bi-fullscreen')
    icon.classList.toggle('bi-fullscreen-exit')

    const tooltip = this.application.getControllerForElementAndIdentifier(button, 'tooltip')
    if (tooltip) {
      tooltip.hide()
      if (icon.classList.contains('bi-fullscreen')) {
        tooltip.setContent('Maximizar')
      } else {
        tooltip.setContent('Restaurar')
      }
    }
  }

  reloadTop () {
    // FIXME: rename to main?
    const topFrame = document.querySelector('#top')
    if (topFrame.attributes.src) {
      topFrame.reload()
    } else {
      topFrame.setAttribute('src', window.location)
    }
  }

  back (ev) {
    this.history.pop()
    if (this.history.length > 0) {
      const url = this.history[this.history.length - 1]
      const frame = this.element.querySelector('#modal_content')
      frame.src = url
      frame.innerHTML = '<div style="min-height: 30em">Cargando...</div>'
    } else {
      this.modalPuntero.hide()
    }
    ev.stopPropagation()
    this.reloadTop()
  }

  openModal () {
    this.modalPuntero.show()
  }

  remove () {
    this.element.remove()
  }

  disconnect (e) {
    // Antes, en lugar de quitar el modal-backdrop:
    //        this.modalPuntero.hide()
    // pero tiraba a veces error:
    // TypeError: can't convert null to object, _isWithActiveTrigger
    document.querySelectorAll('.modal-backdrop').forEach((el) => {
      el.remove()
    })
    document.dispatchEvent(new Event('hidden.bs.modal'))
    this.modalPuntero.dispose()
  }
}
