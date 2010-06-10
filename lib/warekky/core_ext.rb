require 'warekky'

module Warekky
  module CoreExt
    def self.included(klass)
      klass.extend(ClassMethods)
      unless klass.respond_to?(:parse_without_warekky)
        klass.instance_eval do
          alias :parse_without_warekky :parse
          alias :parse :parse_with_warekky
        end
      end
      unless klass.instance_methods.include?('strftime_without_warekky')
        klass.module_eval do
          alias_method :strftime_without_warekky, :strftime
          alias_method :strftime, :strftime_with_warekky
        end
      end
    end

    module ClassMethods
      def eras
        Warekky.era_group
      end

      def parse_with_warekky(str)
        eras.parse(str, :class => self)
      end
    end

    def strftime_with_warekky(format)
      self.class.eras.strftime(self, format)
    end
    
    def era
      self.class.eras[self]
    end
    
    def self.setup
      [::Time, ::Date].each do |klass|
        klass.send(:include, self)
      end
      ::DateTime.instance_eval do
        alias :parse :parse_with_warekky
      end
    end

  end
end
