module Spree
  module Admin
    module Actions
      class OrdersDefaultActionsBuilder
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
