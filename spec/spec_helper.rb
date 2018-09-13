# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'

$LOAD_PATH << File.expand_path('../lib', __dir__)

require 'blackjack'

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter,
    SimpleCov.formatter = SimpleCov::Formatter::Console
  ])

  SimpleCov.start
end
