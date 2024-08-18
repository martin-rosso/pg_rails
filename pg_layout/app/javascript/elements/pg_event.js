class PgEventElement extends HTMLElement {
  connectedCallback () {
    this.dispatchEvent(new MessageEvent(this.dataset.eventName, { bubbles: true, data: this }))
  }

  disconnectedCallback () {
  }
}

if (customElements.get('pg-event') === undefined) {
  customElements.define('pg-event', PgEventElement)
}
