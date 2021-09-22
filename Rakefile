require 'rake'
require 'rubygems/package_task'
require 'thor/group'
begin
  require 'spree/testing_support/common_rake'
rescue LoadError
  raise "Could not find spree/testing_support/common_rake. You need to run this command using Bundler."
end

SPREE_GEMS = %w(backend).freeze

task default: :test

desc "Runs all tests in all Spree engines"
task test: :test_app do
  SPREE_GEMS.each do |gem_name|
    Dir.chdir("#{File.dirname(__FILE__)}/#{gem_name}") do
      sh 'rspec'
    end
  end
end

desc "Generates a dummy app for testing for every Spree engine"
task :test_app do
  SPREE_GEMS.each do |gem_name|
    Dir.chdir("#{File.dirname(__FILE__)}/#{gem_name}") do
      sh 'rake test_app'
    end
  end
end

desc "clean the whole repository by removing all the generated files"
task :clean do
  rm_f  "Gemfile.lock"
  rm_rf "sandbox"
  rm_rf "pkg"

  SPREE_GEMS.each do |gem_name|
    rm_f  "#{gem_name}/Gemfile.lock"
    rm_rf "#{gem_name}/pkg"
    rm_rf "#{gem_name}/spec/dummy"
  end
end
