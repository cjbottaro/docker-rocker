module DockerRocker
  module Build
    module Plugin

      def self.included(klass)
        klass.extend(ClassMethods); super
        PluginManager.register(klass)
      end

      attr_reader :manager

      def initialize(manager)
        @manager = manager
        @context = {}
      end

      def context
        @context
      end

      def engine
        manager.engine
      end

      def commands
        self.class.commands
      end

      module ClassMethods

        def instructions
          @instructions ||= {}
        end

        def transformations
          @transformations ||= {}
        end

        def expand(instruction, &block)
          instruction = instruction.to_s.gsub(/\s+/, " ").strip.upcase
          instructions[instruction] = block
        end

        def transform(regex = /.+/, &block)
          transformations[regex] = block
        end

      end

    end
  end
end
