import { Controller } from '@hotwired/stimulus'
import { flashMessage } from '../utils/utils'
import { get } from '@rails/request.js'

export default class extends Controller {
  async submit () {
    const quantity = this.element.querySelector('input[name=quantity]').value
    const type = this.element.querySelector('select[name=type]').value
    const direction = this.element.querySelector('select[name=direction]').value
    const fechaEl = document.getElementById(this.element.dataset.fieldId)
    const fecha = fechaEl.value
    // console.log(quantity, type, direction)
    this.element.querySelector('button').setAttribute('disabled', 'true')
    // let input = this
    let response = await get('/u/jump_date', { query: { fecha, quantity, type, direction }, responseKind: 'json' })

    response = { date: '2024-10-05' }
    fechaEl.value = response.date
    this.element.querySelector('button').removeAttribute('disabled')
    const popover = this.element.closest('.popover')
    this.application.getControllerForElementAndIdentifier(popover, 'popover').close()
    flashMessage('cosas', 'alert', true)
  }
}
