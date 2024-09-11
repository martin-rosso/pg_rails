import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  popover = null

  connect () {
    const container = this.element.closest('.modal-body') ? '.modal-body' : 'body'
    this.popover = new bootstrap.Popover(this.element, {
      // WARNING: don't use for user input html
      sanitize: false,
      container,
      template: `
<div class="popover" role="tooltip" data-controller="popover">
  <div class="popover-arrow"></div>
  <div class="popover-header"></div>
  <button type="button" class="btn-close position-absolute" data-action="popover#close" style="top: 1em; right: 1em;" aria-label="Close"></button>
  <div class="popover-body">
  </div>
</div>
      `
    })
  }

  disconnect () {
    if (this.popover) {
      // setTimeout because of:
      // https://github.com/twbs/bootstrap/issues/37474
      setTimeout(() => {
        this.popover.dispose()
      }, 300)
    }
  }
}
