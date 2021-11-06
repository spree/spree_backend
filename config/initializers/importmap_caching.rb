if Rails.env.development? && Rails.application.importmap
  Rails.application.importmap.cache_sweeper watches: [
    Rails.application.root.join("app/javascript"),
    Spree::Backend::Engine.root.join("app/assets/javascripts/spree/dashboard"),
  ]
end
