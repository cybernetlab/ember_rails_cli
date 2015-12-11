module EmberRailsCli
  # Gem identity information.
  module Identity
    def self.name
      'ember_rails_cli'
    end

    def self.label
      'EmberRailsCli'
    end

    def self.version
      '2.2.0.1'
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
