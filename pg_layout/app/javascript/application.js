import './config'
import './channels'
import './controllers'
import './elements'

import { Turbo } from '@hotwired/turbo-rails'

import Trix from 'trix'

document.addEventListener('trix-before-initialize', (ev) => {
  Trix.config.lang.attachFiles = 'Adjuntar archivos'
  Trix.config.lang.bold = 'Negrita'
  Trix.config.lang.bullets = 'Lista sin números'
  Trix.config.lang.byte = 'Byte'
  Trix.config.lang.bytes = 'Bytes'
  Trix.config.lang.captionPlaceholder = 'Agregá un subtítulo'
  Trix.config.lang.code = 'Monospace'
  Trix.config.lang.heading1 = 'Título'
  Trix.config.lang.indent = 'Incrementar nivel'
  Trix.config.lang.italic = 'Cursiva'
  Trix.config.lang.link = 'Linkear'
  Trix.config.lang.numbers = 'Lista numerada'
  Trix.config.lang.outdent = 'Disminuir nivel'
  Trix.config.lang.quote = 'Cita'
  Trix.config.lang.redo = 'Rehacer'
  Trix.config.lang.remove = 'Quitar'
  Trix.config.lang.strike = 'Tachar'
  Trix.config.lang.undo = 'Deshacer'
  Trix.config.lang.unlink = 'Deslinkear'
  Trix.config.lang.url = 'URL'
  Trix.config.lang.urlPlaceholder = 'Ingresá una URL'
})

document.addEventListener('pg:record-created', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

document.addEventListener('pg:record-updated', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

document.addEventListener('pg:record-destroyed', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

document.addEventListener('turbo:before-fetch-request', (ev) => {
  // Si es POST, quito la opción text/vnd.turbo-stream.html para que
  // on successful redirect no haya posibilidad de que se abra un modal
  // FIXME: buscar una manera mejor de hacerlo porque es para problemas
  //        quizás, con la movida de abrir modales desde JS
  if (ev.detail.fetchOptions.method.toLowerCase() === 'post') {
    ev.detail.fetchOptions.headers.Accept = 'text/html, application/xhtml+xml'
  }

  if (document.querySelector('.modal.show')) {
    ev.detail.fetchOptions.headers['Modal-Opened'] = true
  }
})
