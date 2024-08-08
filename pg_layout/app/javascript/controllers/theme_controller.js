import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="theme"
export default class extends Controller {
  dark () {
    document.documentElement.setAttribute('data-bs-theme', 'dark')
  }

  light () {
    document.documentElement.setAttribute('data-bs-theme', 'light')
  }
}
