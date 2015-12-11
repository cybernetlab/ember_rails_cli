require 'babel/transpiler'
require 'sprockets/path_utils'
#require 'sprockets/source_map_utils'
require 'json'
require 'pathname'

module EmberRailsCli
  class BabelProcessor
    VERSION = '1'

    def self.instance
      @instance ||= new
    end

    def self.call(input)
      instance.call(input)
    end

    def initialize(options = {})
      @options = options.merge({
        'blacklist' => (options['blacklist'] || []) + ['useStrict'],
        'sourceMap' => true
      }).freeze

      @cache_key = [
        self.class.name,
        Babel::Transpiler::VERSION,
        Babel::Source::VERSION,
        VERSION,
        @options
      ].freeze

      @app_dirs = Config.apps.map {|app| [app.path.join(app.root).to_s, app]}
    end

    def call(input)
      # ignore non-ember assets
      app = @app_dirs.find {|app| input[:filename].start_with?(app[0])}
      return if app.nil?
      app = app[1]
      # ignore templates
      return if input[:filename].start_with?(app.templates_path.to_s)

      data = input[:data]

      result = input[:cache].fetch(@cache_key + [input[:filename]] + [data]) do
        opts = {
          'sourceRoot' => input[:load_path],
          'moduleRoot' => nil,
          'filename' => input[:filename],
          'filenameRelative' => Sprockets::PathUtils.split_subpath(input[:load_path], input[:filename])
        }.merge(@options)

        opts['moduleId'] ||= app.amd_path(input[:filename])
        Babel::Transpiler.transform(data, opts)
      end

      {data: result['code']}
    end
  end
end
