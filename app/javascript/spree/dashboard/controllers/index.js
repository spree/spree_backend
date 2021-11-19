import { application } from "./application"

import UploadButtonController from "./upload_button_controller"
application.register("upload-button", UploadButtonController)

import SpreeController from "./spree_controller"
application.register("spree", SpreeController)
