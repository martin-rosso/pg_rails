import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  close () {
    const toggler = document.querySelector('[aria-describedby="' + this.element.id + '"]')
    const instance = bootstrap.Popover.getInstance(toggler)
    instance.hide()
  }
}
