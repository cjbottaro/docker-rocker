module Rockerfile
  class Engine

    attr_reader :path, :plugin_manager

    def initialize
      @plugin_manager = PluginManager.new(self)
    end

    def render(path)
      lines = []
      File.open(path) do |f|
        f.each do |line|
          lines += process(line).map(&:strip)
        end
      end
      lines.join("\n").strip
    end

    def process(line)
      line = line.strip

      line = plugin_manager.preprocess(line)

      command, rest = line.strip.split(/\s+/, 2)
      command ||= ""; rest ||= ""
      command = command.upcase

      if (plugin = plugin_manager.command_map[command])
        text = plugin.send("command_#{command}", rest, plugin.context)
      else
        text = passthrough(command, rest)
      end

      if text.nil?
        []
      elsif text == ""
        [""]
      else
        text.split("\n")
      end
    end

    def passthrough(command, rest)
      "#{command.upcase} #{rest}".strip
    end

  end
end
