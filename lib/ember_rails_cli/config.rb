module EmberRailsCli
  module Config
    def self.app(**opts)
      app = App.new(**opts)
      @apps ||= []
      @apps = @apps.reject {|x| x.name == app.name}.push(app)
    end

    def self.apps
      @apps ||= []
    end
  end
end
