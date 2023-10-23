module Spree
  module Admin
    module Tabs
      module DataHook
        def with_data_hook(data_hook)
          @data_hook = data_hook
          self
        end
      end
    end
  end
end
