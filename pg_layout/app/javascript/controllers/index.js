import { application } from './application'

import NavbarController from './navbar_controller'
import NestedController from './nested_controller'
import PgFormController from './pg_form_controller'
import FadeinOnloadController from './fadein_onload_controller'
import ClearTimeoutController from './clear_timeout_controller'
import SwitcherController from './switcher_controller'
import FiltrosController from './filtros_controller'
import NotificationsController from './notifications_controller'
import SelectizeController from './selectize_controller'
import ThemeController from './theme_controller'

application.register('navbar', NavbarController)
application.register('nested', NestedController)
application.register('pg_form', PgFormController)
application.register('fadein_onload', FadeinOnloadController)
application.register('clear-timeout', ClearTimeoutController)
application.register('switcher', SwitcherController)
application.register('filtros', FiltrosController)
application.register('notifications', NotificationsController)
application.register('selectize', SelectizeController)
application.register('theme', ThemeController)

// TODO: testear con capybara todo lo que se pueda
