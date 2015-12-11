require 'pathname'

module EmberRailsCli
  class App
    attr_reader *%i(name path root templates stylesheets)

    def initialize(name: nil, path: nil, root: 'app', templates: 'templates', stylesheets: 'styles')
      name = name.to_s if name.is_a?(Symbol)
      name = nil unless name.is_a?(String)
      path = new Pathname(path) if path.is_a?(String)
      path = nil unless path.is_a?(Pathname)
      root = 'app' unless root.is_a?(String)
      templates = 'templates' unless templates.is_a?(String)
      stylesheets = 'styles' unless stylesheets.is_a?(String)
      if name.nil? && path.nil?
        raise new ArgumentError('You should specify either application name or application path')
      end
      name = path.basename if name.nil?
      path = Rails.root.join(name) if path.nil?
      path = path.expand_path(Rails.root) unless path.absolute?
      unless path.directory?
        raise new ArgumentError('You should provide Ember root project folder in `path`')
      end
      unless path.join(root).directory?
        raise new ArgumentError("Your Ember root project folder should contain root application folder #{root}")
      end
      @name = name.freeze
      @path = path.freeze
      @root = root.freeze
      @templates = templates.freeze
      @stylesheets = stylesheets.freeze
    end

    def index
      return @index unless @index.nil?
      file = @path.join(@root, 'index.html')
      file.exist? ? (@index = File.read(file)) : nil
    end

    def root_path
      @root_path ||= @path.join(@root)
    end

    def templates_path
      @templates_path ||= @path.join(@root, @templates)
    end

    def stylesheets_path
      @stylesheets_path ||= @path.join(@root, @stylesheets)
    end

    def amd_name(file)
      path = Pathname.new(file)
      if path.absolute?
        path = path.relative_path_from(root_path)
      else
        if (path.to_s.start_with?(root + File::SEPARATOR))
          path = Pathname.new(path.to_s.split(File::SEPARATOR)[1..-1].join(File::SEPARATOR))
        end
      end
      path.dirname.join(path.basename('.*')).cleanpath.to_s
    end

    def amd_path(file)
      File.join(name, amd_name(file))
    end
  end
end
