require "rockerfile/plugin"

module Rockerfile
  module Plugins
    class Base
      include Plugin

      command "SET" do |line, context|
        k, v = line.split
        raise "invalid SET command: too many arguments: #{line}" if k.kind_of?(Array) || v.kind_of?(Array)
        context[:set] ||= {}
        context[:set][k] = v unless context[:set].has_key?(v)
        nil
      end

      command "INCLUDE" do |line, context|
        raise "invalid INCLUDE command: too many arguments: #{line}" if line =~ /\s+/
        engine.render(line)
      end

      command "DADD" do |line, context|
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

      def preprocess(line, context)
        (context[:set] || {}).each do |k, v|
          line = line.gsub(/#{k}/, v)
        end
        line
      end

    end
  end
end
