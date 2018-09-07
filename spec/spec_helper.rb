# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'

$LOAD_PATH << File.expand_path('../lib', __dir__)

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.formatter = SimpleCov::Formatter::Console
  SimpleCov.start
end
