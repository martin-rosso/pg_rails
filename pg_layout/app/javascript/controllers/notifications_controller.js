import { Controller } from '@hotwired/stimulus'
import { post } from '@rails/request.js'
import { Rollbar } from 'rollbar'

// Connects to data-controller="notifications"
export default class extends Controller {
  timeoutId = null

  connect () {
    this.element.addEventListener('shown.bs.collapse', event => {
      this.timeoutId = setTimeout(() => {
        this.markAsSeen()
      }, 2000)
      document.addEventListener('turbo:load', () => { this.cancelTimeout() })
    })
    this.element.addEventListener('hide.bs.collapse', event => {
      clearTimeout(this.timeoutId)
    })
  }

  async markAsUnseen (e) {
    const notification = e.target.closest('.notification')
    notification.dataset.markedAsUnseen = true
    const id = notification.dataset.id
    const response = await post('/u/notifications/mark_as_unseen',
      { query: { id } })

    if (response.ok) {
      notification.classList.add('unseen')
    } else {
      const text = await response.text
      Rollbar.error('Error marking as unseen: ', text)
    }
  }

  async markAsSeen () {
    const ids = []
    const targets = Array.from(document.querySelectorAll('.notification')).filter((e) => {
      return !e.dataset.markedAsUnseen
    })
    targets.forEach((e) => { ids.push(e.dataset.id) })

    const response = await post('/u/notifications/mark_as_seen',
      { query: { ids }, responseKind: 'turbo-stream' })

    if (response.ok) {
      targets.forEach(
        (notif) => {
          notif.classList.remove('unseen')
        }
      )
      document.querySelectorAll('.notifications-unseen-mark').forEach((e) => {
        e.remove()
      })
    } else {
      const text = await response.text
      Rollbar.error('Error marking as seen: ', text)
    }
  }

  cancelTimeout () {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }
}
