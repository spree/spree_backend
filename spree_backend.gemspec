# encoding: UTF-8
require_relative 'lib/spree/backend/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_backend'
  s.version     = Spree::Backend.version
  s.authors     = ['Sean Schofield', 'Spark Solutions']
  s.email       = 'hello@spreecommerce.org'
  s.summary     = 'Admin Dashboard for Spree eCommerce platform'
  s.description = 'Admin Dashboard for Spree eCommerce platform'
  s.homepage    = 'https://spreecommerce.org'
  s.license     = 'BSD-3-Clause'

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/spree/spree_backend/issues",
    "changelog_uri"     => "https://github.com/spree/spree_backend/releases/tag/v#{s.version}",
    "documentation_uri" => "https://docs.spreecommerce.org/",
    "source_code_uri"   => "https://github.com/spree/spree_backend/tree/v#{s.version}",
  }

  s.required_ruby_version = '>= 3.0'

  s.files        = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', ">= 4.7.0"

  s.add_dependency 'babel-transpiler', '~> 0.7'
  s.add_dependency 'bootstrap',        '~> 4.0'
  s.add_dependency 'flag-icons-rails', '~> 3.4'
  s.add_dependency 'flatpickr', '~> 4.6'
  s.add_dependency 'glyphicons', '~> 1.0'
  s.add_dependency 'turbo-rails'
  s.add_dependency 'stimulus-rails'
  s.add_dependency 'importmap-rails'
  s.add_dependency 'inline_svg', '~> 1.5'
  s.add_dependency 'jquery-rails', '~> 4.3'
  s.add_dependency 'jquery-ui-rails', '>= 6', '< 8'
  s.add_dependency 'responders'
  s.add_dependency 'requestjs-rails'
  s.add_dependency 'sass-rails',       '>= 5'
  s.add_dependency 'select2-rails',    '~> 4.0.6'
  s.add_dependency 'sprockets',        '~> 4.0'
  s.add_dependency 'tinymce-rails',    '~> 5.0'
end
