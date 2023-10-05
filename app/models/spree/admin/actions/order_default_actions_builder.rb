module Spree
  module Admin
    module Actions
      class OrderDefaultActionsBuilder
        include Spree::Core::Engine.routes.url_helpers

        def build
          root = Root.new
          root
        end

        private
      end
    end
  end
end
