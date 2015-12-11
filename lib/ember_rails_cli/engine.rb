require 'ember_rails_cli/babel_processor'
require 'ember_rails_cli/directive_processor'
require 'ember_rails_cli/handlebars_processor'

module EmberRailsCli
  class Engine < ::Rails::Engine
    isolate_namespace EmberRailsCli

    initializer 'ember_rails_cli.precompile' do |app|
      app.config.assets.precompile += Config.apps.flat_map do |app|
        ["#{app.name}.js", "#{app.name}.css", File.join(*%w(config environment))]
      end
      app.config.assets.paths += Config.apps.map(&:root_path)

      app.config.assets.configure do |env|
        babel = BabelProcessor.new(
          'modules'   => 'amd',
          'moduleIds' => true,
        )
        env.register_preprocessor 'application/javascript', babel
        env.unregister_processor  'application/javascript', Sprockets::DirectiveProcessor
        env.register_processor    'application/javascript', DirectiveProcessor
        env.unregister_processor  'text/css',               Sprockets::DirectiveProcessor
        env.register_processor    'text/css',               DirectiveProcessor
        env.register_engine       '.hbs',        HandlebarsProcessor, mime_type: 'application/javascript'
        env.register_engine       '.hjs',        HandlebarsProcessor, mime_type: 'application/javascript'
        env.register_engine       '.handlebars', HandlebarsProcessor, mime_type: 'application/javascript'
      end

      Ember::Handlebars::Template.setup Sprockets
    end
  end
end
