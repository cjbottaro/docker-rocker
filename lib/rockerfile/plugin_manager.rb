module Rockerfile
  class PluginManager

    attr_reader :engine, :plugins

    def initialize(engine)
      @engine = engine
      @plugins = []
      @instruction_map = {}
      @transformation_map = {}

      self.class.plugins.each do |plugin_class|
        plugin = plugin_class.new(self)

        plugin_class.instructions.keys.each do |instruction|
          @instruction_map[instruction] ||= []
          @instruction_map[instruction] << plugin
        end

        plugin_class.transformations.keys.each do |regex|
          @transformation_map[regex] = plugin
        end
      end
    end

    def each_transformation(line, &block)
      @transformation_map.each do |regex, plugin|
        if match = line.match(regex)
          code = plugin.class.transformations[regex]
          block.call(plugin, code, match)
        end
      end
    end

    def each_instruction(instruction, &block)
      (@instruction_map[instruction] || []).each do |plugin|
        code = plugin.class.instructions[instruction]
        block.call(plugin, code)
      end
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
