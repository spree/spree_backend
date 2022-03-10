source 'https://rubygems.org'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

%w[
  actionmailer actionpack actionview activejob activemodel activerecord
  activestorage activesupport railties
].each do |rails_gem|
  gem rails_gem, ENV.fetch('RAILS_VERSION', '~> 7.0.0'), require: false
end

platforms :jruby do
  gem 'jruby-openssl'
end

platforms :ruby do
  if ENV['DB'] == 'mysql'
    gem 'mysql2'
  else
    gem 'pg', '~> 1.1'
  end
end

group :test do
  gem 'capybara', '~> 3.24'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'capybara-select-2'
  gem 'database_cleaner', '~> 2.0'
  gem 'email_spec'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'multi_json'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'rspec-rails', '~> 5.0'
  gem 'rspec-retry'
  gem 'rspec_junit_formatter'
  gem 'rswag-specs'
  gem 'jsonapi-rspec'
  gem 'simplecov', '0.17.1'
  gem 'webmock', '~> 3.7'
  gem 'timecop'
  gem 'rails-controller-testing'
end

group :test, :development do
  gem 'awesome_print'
  gem 'gem-release'
  gem 'redis'
  gem 'rubocop', '~> 1.22.3', require: false # bumped
  gem 'rubocop-rspec', require: false
  gem 'pry-byebug'
  gem 'webdrivers', '~> 4.1'
  gem 'puma'
  gem 'ffaker'
end

group :development do
  gem 'github_fast_changelog'
  gem 'solargraph'
end

spree_opts = { github: 'spree/spree', branch: 'main' }
gem 'spree_core', spree_opts
gem 'spree_api', spree_opts

gemspec
