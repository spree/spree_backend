module Spree
  module Admin
    module MainMenu
      class Root < Section
        attr_reader :items

        def initialize
          super('root', 'root', nil, nil, [])
        end
      end
    end
  end
end
