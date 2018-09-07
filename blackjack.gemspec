# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blackjack/version'

Gem::Specification.new do |spec|
  spec.name          = 'blackjack'
  spec.version       = Blackjack::VERSION
  spec.authors       = ['Ivan Rastyapin']
  spec.email         = ['i.rastypain@gmail.com']

  spec.summary       = 'Ruby implementation Blackjack game for console'
  spec.description   = 'This gem allow to play Blackjack one-to-one with dealer'
  spec.homepage      = 'https://github.com/irastypain/blackjack'
  spec.license       = 'MIT'

  spec.add_runtime_dependency 'commander', '~> 4.4'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.58'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'simplecov-console', '~> 0.4'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end 
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
