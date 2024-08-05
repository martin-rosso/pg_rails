export function setCookie (cname, cvalue, exdays) {
  const d = new Date()
  d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000))
  const expires = 'expires=' + d.toUTCString()
  document.cookie = cname + '=' + cvalue + ';' + expires + ';path=/'
}

export function getCookie (cname) {
  const name = cname + '='
  const ca = document.cookie.split(';')
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i]
    while (c.charAt(0) === ' ') {
      c = c.substring(1)
    }
    if (c.indexOf(name) === 0) {
      return c.substring(name.length, c.length)
    }
  }
  return ''
}

export function round (value) {
  return Math.round(value * 100) / 100
}

export function printCurrency (value, simboloMoneda = '$') {
  if (typeof value === 'string') {
    value = parseFloat(value)
  }
  const decimals = (value % 1 > 0) ? 2 : 0
  return simboloMoneda + ' ' + numberWithDots(value.toFixed(decimals).replace('.', ','))
}

export function showPercentage (value) {
  return '% ' + value
}

export function numberWithDots (x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
}

export function flashMessage (message, flashType = 'warning', toast = false) {
  const el = document.createElement('div')
  const toastClasses = toast ? 'position-absolute pg-toast' : ''
  let iconClasses
  let alertClassSuffix
  switch (flashType) {
    case 'critical':
      iconClasses = 'bi bi-exclamation-triangle-fill me-3 fs-2'
      alertClassSuffix = 'danger'
      break
    case 'alert':
      iconClasses = 'bi bi-exclamation-triangle-fill me-2'
      alertClassSuffix = 'danger'
      break
    case 'warning':
      iconClasses = 'bi bi-exclamation-circle me-2'
      alertClassSuffix = 'warning'
      break
    case 'success':
      iconClasses = 'bi bi-check-lg me-2'
      alertClassSuffix = 'success'
      break
    case 'notice':
    default:
      iconClasses = 'bi bi-info-circle me-2'
      alertClassSuffix = 'info'
      break
  }

  el.innerHTML = `
    <div class="alert alert-dismissible mt-2 d-flex align-items-center alert-${alertClassSuffix} ${toastClasses}"
      data-turbo-temporary="true" data-bs-autohide="true" aria-live="assertive" aria-atomic="true" role="alert">

      <span class="${iconClasses}"></span>
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>`
  document.querySelector('#flash').appendChild(el.children[0])
}

export function fadeOut (e) {
  if (e && window.getComputedStyle(e).visibility !== 'hidden') {
    e.classList.add('fade-out')
    e.addEventListener('animationend', onAnimationEndHide, { once: true })
  }
}

export function fadeIn (e) {
  if (e && window.getComputedStyle(e).visibility !== 'visible') {
    e.classList.add('fade-in')
    e.addEventListener('animationend', onAnimationEndShow, { once: true })
  }
}

function onAnimationEndShow (e) {
  e.target.style.visibility = 'visible'
  e.target.classList.remove('fade-in')
}

function onAnimationEndHide (e) {
  e.target.style.visibility = 'hidden'
  e.target.classList.remove('fade-out')
}
