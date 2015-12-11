module EmberRailsCli
  class DirectiveProcessor < Sprockets::DirectiveProcessor
    def process_require_ember_apps_directive
      Config.apps.each do |app|
        path = get_app_path(app)
        require_paths(*@environment.stat_sorted_tree_with_dependencies(path)) unless path.nil?
      end
    end

    def process_require_ember_app_directive(name = nil)
      app = Config.apps.find { |app| app.name == name } unless name.nil?
      app = Config.apps.find { |app| @filename.start_with?(app.path.to_s) } if app.nil?
      app = Config.apps.find { |app| app.name == File.basename(@filename, '.*') } if app.nil?
      unless app.nil?
        path = get_app_path(app)
        require_paths(*@environment.stat_sorted_tree_with_dependencies(path)) unless path.nil?
      end
    end

    private

    def get_app_path(app)
      if @content_type == 'application/javascript'
        path = app.root_path.to_s
      elsif @content_type == 'text/css'
        path = app.stylesheets_path.to_s
      end
    end
  end
end
