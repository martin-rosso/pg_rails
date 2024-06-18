import * as bootstrap from 'bootstrap'

document.addEventListener('turbo:load', bindTooltips)
document.addEventListener('turbo:render', bindTooltips)

function bindTooltips () {
  const tooltipsQuery = '[data-bs-toggle="tooltip"]'

  const toastElList = document.querySelectorAll(tooltipsQuery)
  Array.from(toastElList).map(tooltipEl => {
    return new bootstrap.Tooltip(tooltipEl)
  })
}
