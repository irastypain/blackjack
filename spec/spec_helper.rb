# frozen_string_literal: true

$LOAD_PATH << File.expand_path('../lib', __dir__)

require 'rspec'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end
