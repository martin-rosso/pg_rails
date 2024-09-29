import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="clear-timeout"
export default class extends Controller {
  connect () {
    if (this.element.dataset.timeoutId) {
      this.element.dataset.timeoutId.split(',').forEach((el) => {
        this.clear(el)
      })
    } else {
      const headId = document.head.dataset.timeoutId
      if (headId) {
        headId.split(',').forEach((el) => {
          this.clear(el)
        })
      }
    }
    this.element.remove()
  }

  clear (id) {
    const timeoutId = parseInt(id)
    clearTimeout(timeoutId)
    console.log(`clearedTimeout: ${timeoutId}`)
  }
}
