require "docker_rocker/build/plugin"

module DockerRocker
  module Plugins
    class BuiltIn
      include Build::Plugin

      expand "SET" do |line|
        k, v = line.split
        raise "invalid SET command: too many arguments: #{line}" if k.kind_of?(Array) || v.kind_of?(Array)

        context[:set] ||= {}
        context[:set][k] = v unless context[:set].has_key?(v)

        nil
      end

      expand "INCLUDE" do |line|
        raise "invalid INCLUDE command: too many arguments: #{line}" if line =~ /\s+/

        engine.render(line)
      end

      expand "DADD" do |line|
        src, dst = line.split
        raise "invalid DADD command: too many arguments: #{line}" if src.kind_of?(Array) || dst.kind_of?(Array)

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

      transform /.+/ do |line, match|
        (context[:set] || {}).each do |k, v|
          line = line.gsub(/#{k}/, v)
        end
        line
      end

    end
  end
end
