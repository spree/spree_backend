/* eslint-disable no-undef */

import { Application } from "@hotwired/stimulus"
if (!window.Stimulus) { window.Stimulus = Application.start() }

import UploadButtonController from "./upload_button_controller"
Stimulus.register("upload-button", UploadButtonController)

import SpreeController from "./spree_controller"
Stimulus.register("spree", SpreeController)

import SortableTreeController from "./sortable_tree_controller"
Stimulus.register("sortable-tree", SortableTreeController)

import WebhooksSubscriberEventsController from "./webhooks_subscriber_events_controller"
Stimulus.register("webhooks-subscriber-events", WebhooksSubscriberEventsController)

import PasswordToggleController from "./password_toggle_controller"
Stimulus.register("password-toggle", PasswordToggleController)

import ClipboardController from "./clipboard_controller"
Stimulus.register("clipboard", ClipboardController)

import ProductEditController from "./product_edit_controller"
Stimulus.register("product-edit", ProductEditController)
