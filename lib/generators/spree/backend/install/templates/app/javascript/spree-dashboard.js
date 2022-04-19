// Entry point for the build script in your package.json

import "./application" // Load the default rails Turbo setup from application.
import "@spree/dashboard"

new SpreeDashboard.Dashboard()
