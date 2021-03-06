$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'ember_rails_cli/identity'

Gem::Specification.new do |spec|
  spec.name        = EmberRailsCli::Identity.name
  spec.version     = EmberRailsCli::Identity.version
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Alexey Ovchinnikov']
  spec.email       = ['alexey.ovchinnikov@yandex.ru']
  spec.homepage    = 'https://github.com/cybernetlab/ember_rails_cli'
  spec.summary     = 'Rails CLI for ember framework'
  spec.description = 'Rails CLI for ember framework'
  spec.license     = 'MIT'

  if ENV['RUBY_GEM_SECURITY'] == 'enabled'
    spec.signing_key = File.expand_path('~/.ssh/gem-private.pem')
    spec.cert_chain = [File.expand_path('~/.ssh/gem-public.pem')]
  end

  spec.add_dependency 'rails', '>= 4.2'
  spec.add_dependency 'babel-transpiler', '~> 0.6'
  spec.add_dependency 'ember-handlebars-template', '~> 0.5'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'gemsmith'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-state'
  spec.add_development_dependency 'pry-rescue'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rb-fsevent' # Guard file events for OSX.
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'terminal-notifier'
  spec.add_development_dependency 'terminal-notifier-guard'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.files = Dir['lib/**/*', 'vendor/**/*']
  spec.extra_rdoc_files = Dir['README*', 'LICENSE*']
  spec.require_paths = ['lib']
end
