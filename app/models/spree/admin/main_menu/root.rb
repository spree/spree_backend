module Spree
  module Admin
    module MainMenu
      class Root < Section
        include ::Spree::Admin::ItemManager

        attr_reader :items

        def initialize
          super('root', 'root', nil, nil, [])
        end
      end
    end
  end
end
