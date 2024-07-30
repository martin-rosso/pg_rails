import { Controller } from '@hotwired/stimulus'
import TomSelect from 'tom-select'

// Connects to data-controller="selectize"
export default class extends Controller {
  connect () {
    /* eslint no-new: 0 */
    new TomSelect(this.element)
  }
}
