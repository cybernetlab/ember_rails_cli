require 'ember/handlebars/template'

module EmberRailsCli
  #Ember::Handlebars::Template.configure do |handlebars_config|
  #  config.handlebars = handlebars_config
  #  config.handlebars.precompile = true
  #  config.handlebars.templates_root = 'templates'
  #  config.handlebars.templates_path_separator = '/'
  #  config.handlebars.output_type = :global
  #  config.handlebars.ember_template = Ember::VERSION =~ /\A1.[0-9]\./ ? 'Handlebars' : 'HTMLBars'
  #end

  class HandlebarsProcessor < Ember::Handlebars::Template
    class << self
      def instance(input)
        app = Config.apps.find { |app| input[:filename].starts_with?(app.templates_path.to_s) }
        return super() if app.nil?
        @instances ||= {}
        return @instances[app.name] if @instances.key?(app.name)
        conf = config
        conf.output_type = :amd
        conf.amd_namespace = app.name
        #p "#{input[:filename]} #{input[:load_path]} #{input[:name]}"
        conf.templates_root = File.join(app.root, app.templates)
        template = @instances[app.name] = new(conf)
        template.instance_variable_set(:@app, app)
        template
      end

      def call(input)
        instance(input).call(input)
      end
    end

    private

    def actual_name(input)
      name = super(input)
      @app ? @app.amd_name(name) : name
    end
  end
end
