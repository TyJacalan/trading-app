// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AutoSubmit from '@stimulus-components/auto-submit'
application.register('auto-submit', AutoSubmit)

import Ui__DialogController from "./ui/dialog_controller"
application.register("ui--dialog", Ui__DialogController)

import Ui__PopoverController from "./ui/popover_controller"
application.register("ui--popover", Ui__PopoverController)

import Ui__SheetController from "./ui/sheet_controller"
application.register("ui--sheet", Ui__SheetController)

import Ui__SwitchController from "./ui/switch_controller"
application.register("ui--switch", Ui__SwitchController)

import Ui__SwitchModeController from "./ui/switch_mode_controller"
application.register("ui--switch-mode", Ui__SwitchModeController)

import Ui__ToastController from "./ui/toast_controller"
application.register("ui--toast", Ui__ToastController)
