import * as bootstrap from 'bootstrap'

const tooltipsQuery = '[data-controller="tooltip"]'

document.addEventListener('show.bs.tooltip', (ev) => {
  const toastElList = document.querySelectorAll(tooltipsQuery)
  Array.from(toastElList).forEach(tooltipEl => {
    const tooltip = bootstrap.Tooltip.getInstance(tooltipEl)
    if (tooltip) {
      tooltip.hide()
    }
  })
})
