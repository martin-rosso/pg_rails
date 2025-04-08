import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'
import { Rollbar } from 'rollbar'

export default class extends Controller {
  static outlets = ['asociable']

  modalPuntero = null
  history = []

  connect (e) {
    this.modalPuntero = new bootstrap.Modal(this.element)
    if (this.element.dataset.removeOnHide === 'true') {
      this.element.addEventListener('hidden.bs.modal', (e) => {
        this.element.remove()
      })
    }
    if (this.element.dataset.autoShow === 'true') {
      this.modalPuntero.show()
    }

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
      if (ev.data.dataset.inline) {
        // Is an inline edit submit
        this.reloadTop()
        ev.stopPropagation()
      } else {
        if (ev.data.dataset.reload) {
          // Must reload modal. Ie: on discard/undiscard
          this.reload()
          this.reloadTop()
          ev.stopPropagation()
        } else {
          // Is a traditional form submit
          this.back(ev)
        }
      }
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

  reload () {
    const frame = this.element.querySelector('turbo-frame')
    if (frame.attributes.src) {
      frame.reload()
    } else {
      Rollbar.error('Modal without frame')
    }
  }

  reloadTop () {
    // TODO!!: rename to main?
    const topFrame = document.querySelector('#top')
    if (topFrame) {
      if (topFrame.attributes.src) {
        topFrame.reload()
      } else {
        topFrame.setAttribute('src', window.location)
      }
    } else {
      window.location.reload()
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
    // document.querySelectorAll('.modal-backdrop').forEach((el) => {
    //   el.remove()
    // })
    // UPDATE: 11-09-2024, vuelvo a poner el hide, porque en parece que
    // el problema de _isWithActiveTrigger viene por el lado de los
    // tooltips:
    // https://github.com/twbs/bootstrap/issues/37474
    this.modalPuntero.hide()
    document.dispatchEvent(new Event('hidden.bs.modal'))
    this.modalPuntero.dispose()
  }
}
