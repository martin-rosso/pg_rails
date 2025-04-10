import './cable_ready'
import './turbo_rails'
import './rollbar'
import './bootstrap'
import './tooltips'

import 'trix'
import '@rails/actiontext'

function bindListingClick () {
  document.body.onclick = (ev) => {
    if (ev.target.closest('a')) return
    if (ev.target.closest('.inline-edit')) return
    if (ev.target.closest('.inline-no-edit')) return
    if (ev.target.closest('.listado')) {
      const row = ev.target.closest('tr')
      if (row) {
        const mainRowLink = row.querySelector('.main-row-link')
        if (mainRowLink) {
          mainRowLink.click()
        } else {
          const show = row.querySelector('.bi-eye-fill')
          if (show) {
            const link = show.closest('a')
            if (link) {
              link.click()
            }
          }
        }
      }
    }
  }
}
bindListingClick()
document.addEventListener('turbo:load', bindListingClick)
document.addEventListener('turbo:render', bindListingClick)
