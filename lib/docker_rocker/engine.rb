module DockerRocker
  class Engine

    attr_reader :path, :plugin_manager

    def initialize
      @plugin_manager = PluginManager.new(self)
      @base_dir = nil
    end

    def render(path)

      # On first invocation, grab the base dir so that we
      # can make recursive invocations relative to it.
      if !@base_dir
        @base_dir = File.dirname(path)
      else
        path = "#{@base_dir}/#{path}"
      end

      lines = []
      File.open(path) do |f|
        f.each do |line|
          lines += process(line)
        end
      end
      lines.join("\n").strip
    end

    def process(line)
      line = line.strip

      plugin_manager.each_transformation(line) do |plugin, code, match|
        line = plugin.instance_exec(line, match, &code)
      end

      instruction, rest = parse_line(line)

      plugin_manager.each_instruction(instruction) do |plugin, code|
        line = plugin.instance_exec(rest, &code)
      end

      line_to_array(line)
    end

    def parse_line(line)
      instruction, rest = line.strip.split(/\s+/, 2)
      instruction ||= ""; rest ||= ""
      instruction = instruction.upcase
      [instruction, rest]
    end

    def line_to_array(line)
      if line.nil?
        []
      elsif line == ""
        [""]
      else
        line.split("\n").map(&:strip)
      end
    end

  end
end
