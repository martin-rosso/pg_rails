import { application } from './application'

import NavbarController from './navbar_controller'
import FadeinOnloadController from './fadein_onload_controller'
import ClearTimeoutController from './clear_timeout_controller'
import SwitcherController from './switcher_controller'
import ThemeController from './theme_controller'
import TooltipController from './tooltip_controller'
import PopoverController from './popover_controller'
import PopoverTogglerController from './popover_toggler_controller'

application.register('navbar', NavbarController)
application.register('fadein_onload', FadeinOnloadController)
application.register('clear-timeout', ClearTimeoutController)
application.register('switcher', SwitcherController)
application.register('theme', ThemeController)
application.register('tooltip', TooltipController)
application.register('popover', PopoverController)
application.register('popover-toggler', PopoverTogglerController)
