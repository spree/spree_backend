module Spree
  module Admin
    module MainMenu
      class Root < Section
        attr_reader :items

        def initialize
          super('root', 'root', nil, [], [])
        end

        def add_to_section(section_key, item)
          @items.find { |e| e.key == section_key }.add(item)
        end
      end
    end
  end
end
