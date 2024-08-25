class PgEventElement extends HTMLElement {
  connectedCallback () {
    const event = new MessageEvent(this.dataset.eventName, { bubbles: true, data: this })
    this.dispatchEvent(event)
  }

  disconnectedCallback () {
  }
}

if (customElements.get('pg-event') === undefined) {
  customElements.define('pg-event', PgEventElement)
}
