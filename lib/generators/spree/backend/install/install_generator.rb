module Spree
  module Backend
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc 'Installs Spree Dashboard'

        def self.source_paths
          [
            File.expand_path('templates', __dir__),
            File.expand_path('../templates', "../#{__FILE__}"),
            File.expand_path('../templates', "../../#{__FILE__}")
          ]
        end

        def install
          template 'app/javascript/spree-dashboard.js'
          template 'vendor/assets/javascripts/spree/backend/all.js'
          template 'vendor/assets/stylesheets/spree/backend/all.css'
          run 'yarn add @spree/dashboard'
        end
      end
    end
  end
end
