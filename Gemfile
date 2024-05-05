source 'https://rubygems.org'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

%w[
  actionmailer actionpack actionview activejob activemodel activerecord
  activestorage activesupport railties
].each do |rails_gem|
  gem rails_gem, ENV.fetch('RAILS_VERSION', '~> 7.1.0'), require: false
end

platforms :jruby do
  gem 'jruby-openssl'
end

platforms :ruby do
  if ENV['DB'] == 'mysql'
    gem 'mysql2'
  elsif ENV['DB'] == 'postgres'
    gem 'pg'
  else
    gem 'sqlite3', '~> 2.0'
  end
end

group :test do
  gem 'tinymce-rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-select-2'
  gem 'database_cleaner', '~> 2.0'
  gem 'email_spec'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'multi_json'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'rspec_junit_formatter'
  gem 'rswag-specs'
  gem 'jsonapi-rspec'
  gem 'simplecov', '0.22.0'
  gem 'webmock'
  gem 'timecop'
  gem 'rails-controller-testing'
  gem 'turbo-rails'
end

group :test, :development do
  gem 'awesome_print'
  gem 'gem-release'
  gem 'redis'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry-byebug'
  gem 'selenium-webdriver'
  gem 'puma'
  gem 'ffaker'
end

group :development do
  gem 'solargraph'
end


spree_opts = { github: 'spree/spree', branch: 'main' }
gem 'spree_core', spree_opts
gem 'spree_api', spree_opts
gemspec
