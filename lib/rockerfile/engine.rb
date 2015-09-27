module Rockerfile
  class Engine

    attr_reader :path, :context

    def initialize(path, context = {})
      @path = path
      @context = context
    end

    def render
      lines = []
      File.open(path) do |f|
        f.each do |line|
          lines << process(line)
        end
      end
      lines.join("\n")
    end

    def process(line)
      command, rest = line.strip.split(/\s+/, 2)
      rest = interpolate_variables(rest)
      if rockerfile_command?(command)
        process_command(command, rest)
      else
        passthrough(command, rest)
      end
    end

    def rockerfile_command?(command)
      %w[SET INCLUDE DADD].include?(command)
    end

    def passthrough(command, rest)
      "#{command.upcase} #{rest}"
    end

    def process_command(command, rest)
      case command.upcase
      when "SET"
        process_set(rest)
      when "INCLUDE"
        process_include(rest)
      when "DADD"
        process_dadd(rest)
      end
    end

    def interpolate_variables(rest)
      context.each do |k, v|
        rest = rest.gsub(/:#{k}/, v)
      end
      rest
    end

    def process_set(rest)
      k, v = rest.split
      raise "invalid SET command: too many arguments: #{rest}" if k.kind_of?(Array) || v.kind_of?(Array)
      context[k] = v unless context.has_key?(k)
      ""
    end

    def process_include(rest)
      rest = rest.strip
      raise "invalid INCLUDE command: too many arguments: #{rest}" if rest =~ /\s+/
      Engine.new(rest, context).render
    end

    def process_dadd(rest)
      src, dst = rest.split

      raise "invalid DADD command: too many arguments: #{rest}" if src.kind_of?(Array) || dst.kind_of?(Array)
      case src
      when /gz$/
        z = "z"
      when /bz2$/
        z = "j"
      else
        z = ""
      end

      <<-STR
COPY #{src} /tmp/
RUN mkdir #{dst}
RUN tar x#{z}f /tmp/#{src} -C #{dst} --strip-components 1
      STR
    end

  end
end
