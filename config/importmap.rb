controllers_path = File.expand_path("../app/javascript/controllers", __dir__)
pin_all_from controllers_path, to: 'controllers', under: 'controllers'

pin 'request_utility', to: 'request_utility'
