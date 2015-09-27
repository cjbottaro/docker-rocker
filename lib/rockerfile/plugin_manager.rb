module Rockerfile
  class PluginManager

    attr_reader :engine, :plugins, :command_map, :preprocessors

    def initialize(engine)
      @engine = engine
      @plugins = []
      @command_map = {}
      @preprocessors = []

      self.class.plugins.each do |plugin_class|
        plugin = plugin_class.new(self)
        @plugins << plugin
        plugin.commands.each{ |command| @command_map[command] = plugin }
        @preprocessors << plugin if plugin.respond_to?(:preprocess)
      end
    end

    def preprocess(line)
      preprocessors.inject(line){ |memo, plugin| plugin.preprocess(memo, plugin.context) }
    end

    @plugins = []

    singleton_class.class_eval do

      attr_reader :plugins

      def register(plugin)
        plugins << plugin
      end

    end

  end
end
