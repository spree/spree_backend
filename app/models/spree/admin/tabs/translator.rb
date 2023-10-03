module Spree
  module Admin
    module Tabs
      module Translator
        def with_custom_translator(klass, method)
          @translate = lambda do |name|
            klass.send(method, name)
          end
          self
        end
      end
    end
  end
end
