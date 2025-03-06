
7.6.32 / 2025-03-06
===================

  * feat: bulk edit
  * feat: clicking on table row opens the item
  * build: add bulky dependency

7.6.31 / 2025-02-27
===================

  * fix: suppress falsa alarm on CSRF verification (ActionController::InvalidCrossOriginRequest)

7.6.30 / 2025-02-05
===================

  * feat: robots meta tag customisation

7.6.29 / 2025-02-04
===================

  * fix: health ssl check in a separate process

7.6.28 / 2025-01-22
===================

  * feat: tooltip en checkbox de recordar sesión
  * fix: floating labels on sign in. devise links fix
  * test: check SSL certificates in health controller

7.6.27 / 2025-01-10
===================

  * test: users de prueba sin nombre y apellido

7.6.26 / 2025-01-10
===================

  * feat: user_root_path redirects to tenant_root_path
  * test: explicito la version de undercover

7.6.25 / 2025-01-10
===================

  * feat: sign up mejorado
  * feat: Auto sign in al confirmar email
  * fix: set z-index on flash-container
  * fix: simple form wrapper for bootstrap floating labels

7.6.24 / 2025-01-07
=====================

  * fix: export en excel sin html
  * refactor: reestructuración scss y js (para la landing)
  * fix: logo width overflow

7.6.23 / 2024-11-22
===================

  * feat: context_root_path helper
  * feat: show theme links only to dev user
  * feat: allow to skip the csrf meta tags in base layout
  * fix: move dev_user? to helper module
  * fix: urls en decorator
  * doc: fixme comment

7.6.22 / 2024-11-09
===================

  * fix: cache favicon with brand name
  * fix: default url options, merge default action controller config
  * fix: load precompiled asset in base mailer
  * fix: invitations validation errors
  * test: set app_name in mailer previews

7.6.21 / 2024-11-08
===================

  * feat: espacios
  * feat: site brands
  * feat: show user list to guests
  * feat: logos
  * fix: base policy, allow edit if created by self
  * test: fix draper view_context leakage on jobs specs

7.6.20 / 2024-10-21
===================

  * test: resource reports

7.6.19 / 2024-10-18
==================

  * fix(minor): show layout
  * fix(minor): index
  * feat: allow turbo prefetch

7.6.18 / 2024-10-17
==================

  * feat: archivar y desarchivar resources

7.6.17 / 2024-10-14
==================

  * fix: naming concern to share with noticed models

7.6.16 / 2024-10-14
==================

  * admin: simple user notifier controller

7.6.15 / 2024-10-11
==================

  * fix: inline edit pg-event handling

7.6.14 / 2024-10-11
==================

  * fix: max size for trix attachments
  * fix: date autosubmit dont work

7.6.13 / 2024-10-11
==================

  * fix: send updated js event when inline edit

7.6.12 / 2024-10-11
==================

  * fix: multimodal

7.6.11 / 2024-10-11
==================

  * fix: pg_asociable API

7.6.10 / 2024-10-11
==================

  * fix: inline & asociable fixes

7.6.9 / 2024-10-11
==================

  * feat: autosubmit inline forms
  * fix: asociable UX improvements

7.6.8 / 2024-10-11
==================

  * feat: show file attachments in trix
  * fix: using modal was broken

7.6.7 / 2024-10-10
==================

  * feat: inline edit time fields
  * feat: date jumper en inline edit
  * feat: automatically save inline edit when created associable object

7.6.6 / 2024-10-10
==================

  * feat: allow multiple modals for pg_associable from a modal
  * fix: deny user creation from associable
  * fix: inline edit in listings

7.6.5 / 2024-10-10
==================

  * fix: support inline edit rich text

7.6.4 / 2024-10-10
==================

  * fix: support inline edit suffixed attributes

7.6.3 / 2024-10-10
==================

  * feat: inline edit
  * fix: pg_asociable filter out discarded items

7.6.2 / 2024-09-30
==================

  * feat: check websocket server in health controller
  * fix: dont create Account on signup when tenant present
  * fix(minor): gender locale for devise fields
  * ci: install only chrome, not firefox

7.6.1 / 2024-09-30
==================

  * feat: dummy dashboard

7.6.0 / 2024-09-29
==================

  * fix!: new object-oriented navigation schema
  * fix: handle unknown format
  * fix: show unscoped accounts in switcher
  * fix: pg_asociable disable nested model
  * fix: clear timeout with timeoutId in DOM
  * fix: webhooks controller without tenant
  * build!: yarn 4
  * build: ostruct gem

7.5.7 / 2024-09-20
==================

  * fix: patch ActiveStorage::BaseController for without_tenant
  * fix: login as
  * feat(admin): nested user accounts in account show
  * ci: install ruby-vips & cache apt packages

7.5.6 / 2024-09-19
==================

  * fix: acts_as_tenant en User y UserAccount
  * fix(minor): i18n devise

7.5.5 / 2024-09-14
==================

  * fix: ensures account is active on set_tenant

7.5.4 / 2024-09-13
==================

  * fix: invalidate login if user is discarded
  * fix: deny to login to discarded accounts
  * fix: only require_tenant on users controllers
  * test: tenant on devise email send
  * test: current attributes
  * refactor: RequireTenantSet concern (now raises)
  * refactor: user account profile rename

7.5.3 / 2024-09-12
==================

  * feat: show de account para users

7.5.2 / 2024-09-11
==================

  * refactor!: users & admin controller in pg_engine
  * fix: tooltip dispose
  * fix: tenant en email, email_log y audits

7.5.1 / 2024-09-10
==================

  * fix: set current tenant
  * refactor: require tenant concern

7.5.0 / 2024-09-10
==================

  * feat: account switcher
  * build: acts_as_tenant

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
