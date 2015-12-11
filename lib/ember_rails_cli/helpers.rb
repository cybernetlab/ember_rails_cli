module EmberRailsCli
  module Helpers
    def ember_config_for(app)
      app = app.to_s if app.is_a?(Symbol)
      return '' unless app.is_a?(String)
      app = Config.apps.find { |x| x.name == app }
      return '' if app.nil?
      config = app.path.join(*%w(config environment.js))
      return '' unless config.file?
      js = 'define(\'admin_frontend/config/environment\', [\'ember\'], function(Ember){var module={};'
      js += File.read(config)
      js += ';return module.exports("' + Rails.env + '");});'
      js.html_safe
    end
  end
end
