import { Controller } from '@hotwired/stimulus'
import { flashMessage } from '../utils/utils'
import { get } from '@rails/request.js'
import Rollbar from 'rollbar'

export default class extends Controller {
  today () {
    const fechaEl = document.getElementById(this.element.dataset.fieldId)
    let today = new Date()
    const dd = String(today.getDate()).padStart(2, '0')
    const mm = String(today.getMonth() + 1).padStart(2, '0') // January is 0!
    const yyyy = today.getFullYear()

    today = yyyy + '-' + mm + '-' + dd
    fechaEl.value = today
    return fechaEl.value
  }

  closePopover () {
    const popover = this.element.closest('.popover')
    this.application.getControllerForElementAndIdentifier(popover, 'popover').close()
  }

  async submit () {
    const fechaEl = document.getElementById(this.element.dataset.fieldId)
    let startDate = fechaEl.value
    if (!startDate) {
      startDate = this.today()
    }

    const quantity = this.element.querySelector('input[name=quantity]').value
    if (!quantity) {
      this.closePopover()
      return
    }
    const type = this.element.querySelector('select[name=type]').value
    const direction = this.element.querySelector('select[name=direction]').value
    // console.log(quantity, type, direction)
    this.element.querySelector('button').setAttribute('disabled', 'true')
    // let input = this
    const response = await get('/u/date_jumper/jump', {
      query: {
        start_date: startDate,
        quantity,
        type,
        direction
      },
      responseKind: 'json'
    })

    if (response.ok) {
      const json = await response.json
      fechaEl.value = json.date
      this.element.querySelector('button').removeAttribute('disabled')
      this.closePopover()
    } else {
      let message = 'Hubo un error'
      try {
        const json = await response.json
        message = json.html || 'Hubo un error'
      } catch {
        // JSON parser error
      }
      flashMessage(message, 'warning', true)
      this.element.querySelector('button').removeAttribute('disabled')
      Rollbar.error('date jumper error', json)
    }
  }
}
