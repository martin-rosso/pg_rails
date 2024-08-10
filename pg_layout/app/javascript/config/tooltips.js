import * as bootstrap from 'bootstrap'

document.addEventListener('turbo:load', bindTooltips)
document.addEventListener('turbo:render', bindTooltips)

const tooltipsQuery = '[data-bs-toggle="tooltip"]'

function bindTooltips () {
  const toastElList = document.querySelectorAll(tooltipsQuery)
  Array.from(toastElList).map(tooltipEl => {
    return new bootstrap.Tooltip(tooltipEl)
  })
}

document.addEventListener('show.bs.tooltip', (ev) => {
  const toastElList = document.querySelectorAll(tooltipsQuery)
  Array.from(toastElList).forEach(tooltipEl => {
    const tooltip = bootstrap.Tooltip.getInstance(tooltipEl)
    if (tooltip) {
      tooltip.hide()
    }
  })
})
