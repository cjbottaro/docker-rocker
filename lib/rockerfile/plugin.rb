module Rockerfile
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

      def commands
        @commands ||= []
      end

      def command(name, &block)
        name = name.to_s.strip.upcase
        self.commands << name
        define_method("command_#{name}", &block)
      end

      def preprocess(&block)
        define_method("preprocess", &block)
      end

    end

  end
end
