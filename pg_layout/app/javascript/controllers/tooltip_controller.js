import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  tooltip = null

  connect () {
    this.tooltip = new bootstrap.Tooltip(this.element)
  }

  disconnect () {
    this.tooltip.dispose()
  }
}
