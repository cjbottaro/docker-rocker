module DockerRocker
  class Engine

    attr_reader :path, :plugin_manager

    def initialize(path)
      @path = path
      @base_dir = File.dirname(File.expand_path(path))

      # Search for plugins before initializing the plugin manager.
      tokens = @base_dir.split("/")
      while !tokens.empty?
        directory = tokens.join("/")
        Dir.glob("#{directory}/*.drp.rb").each{ |path| puts path; require(path) }
        tokens.pop
      end

      @plugin_manager = PluginManager.new(self)
    end

    def render(path = nil)

      if path
        path = "#{@base_dir}/#{path}"
      else
        path = @path
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
