Rails.application.config.assets.precompile << 'spree_backend_manifest.js'

Rails.application.config.assets.configure do |env|
  env.export_concurrent = false
  Rails.application.config.active_record.yaml_column_permitted_classes = [Symbol, BigDecimal, ActiveSupport::HashWithIndifferentAccess]
end
