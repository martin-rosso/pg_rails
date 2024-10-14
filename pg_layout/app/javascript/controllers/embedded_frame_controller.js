import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.addEventListener('pg:record-destroyed', (ev) => {
      this.element.querySelector('turbo-frame').reload()
      ev.stopPropagation()
    })
    this.element.addEventListener('pg:record-updated', (ev) => {
      this.element.querySelector('turbo-frame').reload()
      ev.stopPropagation()
    })
  }
}
