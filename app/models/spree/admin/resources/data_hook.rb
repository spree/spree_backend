module Spree
  module Admin
    module Resources
      module DataHook
        def with_data_hook(data_hook)
          @data_hook = data_hook
          self
        end
      end
    end
  end
end
