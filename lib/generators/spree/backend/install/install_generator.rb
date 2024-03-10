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
          template 'vendor/assets/javascripts/spree/backend/all.js'
          template 'vendor/assets/stylesheets/spree/backend/all.css'

          say 'Ensure Request.js are installed'
          run 'bin/rails requestjs:install'

          say 'Pin SortableJS to importmap.rb'
          run 'bin/importmap pin sortablejs'

          say 'Pin Spree Dashboard Stimulus controllers in importmap.rb'

          append_file 'config/importmap.rb', <<-IMPORTS.strip_heredoc
            pin_all_from Spree::Backend::Engine.root.join("app/javascript/controllers"), under: "controllers", to: "controllers"
            pin "request_utility", to: "request_utility"
          IMPORTS
        end
      end
    end
  end
end
