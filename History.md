
7.4.3 / 2024-09-04
==================

  * fix: table columns truncation

7.4.2 / 2024-09-04
==================

  * feat: truncate large table columns

7.4.1 / 2024-09-03
=============

  * fix: actioncable url metatag

7.4.0 / 2024-09-02
==================

  * build: dont require faker/factory_bot on production
  * feat: rate limiting on public controllers
  * fix: handle turbo:frame-missing event
  * fix: pagination overflow fixed

7.3.5 / 2024-08-30
==================

  * fix: skip turbo frame accept header when POST fetch

7.3.4 / 2024-08-30
==================

  * feat: add support for not autoshowing modals

7.3.3 / 2024-08-30
==================

  * fix: don't use main turbo frame on devise views

7.3.2 / 2024-08-30
==================

  * fix: decorator links for no-modal objects

7.3.1 / 2024-08-29
==================

  * feat!: modals & nested frames
  * fix: change date jumper options order
  * fix: show filters by default
  * fix: sort records by id by default
  * fix: ransack memory support for turbo frames

7.3.0 / 2024-08-21
==================

  * feat!: allow modals to be rendered on modal
  * refactor: render common form components automatically
  * fix: breadcrumb consistence when editing name
  * fix: allow popovers on modals
  * fix: kaminari config for ransack memory

7.2.3 / 2024-08-16
==================

  * fix: jumper js fixes

7.2.2 / 2024-08-16
==================

  * fix: date jumper error empty date handling

7.2.1 / 2024-08-16
==================

  * feat: Date jumper
  * feat: popovers
  * feat: bad user input error handling
  * fix!: configurable users controller class
  * build: add holidays dependency
  * fix: list group styles padding

7.2.0 / 2024-08-14
==================

  * build!: upgrade to Rails 7.2 & Ruby 3.3.4
  * build!: update all ruby dependencies

7.1.16 / 2024-08-14
===================

  * feat: progress bar en turbo frames

7.1.15 / 2024-08-13
===================

  * feat: tooltips on contextmenu
  * fix: dispatcheo hidden.bs.modal en el document
  * fix: máximo 3 notifications, y fix de tooltip
  * chore: release script

7.1.14 / 2024-08-12
===================

  * fix!: tooltips ahora se bindean con tooltip_controller
  * fix: search bar y modal

v7.1.13 / 2024-08-12
====================

  * feat: allow only one tooltip instance at a time
  * fix: modal event handling, turbo frames, tooltip style
  * chore: quito sublime project

7.1.12 / 2024-08-08
===================

  * debug: minor fix, quito warning en filtros builder
  * feat: restore background warning subtle color
  * doc: fixme comment
  * feat: theme dark/light switcher
  * fix: trix-content class + fadeIn/Out fix

7.1.11 / 2024-08-03
===================

  * fix: clear filters when hiding + refactor

7.1.10 / 2024-08-03
===================

  * feat: remember active filters
  * feat: highlight active filters
  * doc: release history

7.1.9 / 2024-08-03
==================

  * fix(layout): yield filtros
  * fix: system spec generator
