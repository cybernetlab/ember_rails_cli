require 'ember_rails_cli/identity'
require 'ember_rails_cli/app'
require 'ember_rails_cli/config'
require 'ember_rails_cli/engine'
require 'ember_rails_cli/helpers'

module EmberRailsCli
  def self.config
    config = Config
    yield config if block_given?
    config
  end
end
