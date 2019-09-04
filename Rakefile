# frozen_string_literal: true

require "bundler/setup"
require "rspec/core/rake_task"

desc "Default: run specs."
task default: :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

namespace :doorkeeper do
  desc "Install doorkeeper in dummy app"
  task :install do
    cd "spec/dummy"
    system "bundle exec rails g doorkeeper:install --force"
  end

  desc "Runs local test server"
  task :server do
    cd "spec/dummy"
    system "bundle exec rails server"
  end
end

Bundler::GemHelper.install_tasks
