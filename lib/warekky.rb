require 'date'
require 'time'

module Warekky
  autoload :Era, 'warekky/era'
  autoload :EraGroup, 'warekky/era_group'
  autoload :Ja, 'warekky/ja'
  autoload :CoreExt, 'warekky/core_ext'

  class << self
    attr_writer :era_group
    attr_writer :era_group_class

    def era_group
      @era_group ||= (era_group_class ? era_group_class.new : nil)
    end

    def era_group_class
      @era_group_class = ::Warekky::Ja unless defined?(@era_group_class)
      @era_group_class
    end

    # d: Date or Time
    def strftime(d, format)
      era_group ? 
        era_group.strftime(d, format) : 
        try_without(d, :strftime, format)
    end

    def parse(str, options = {})
      era_group ? 
        era_group.parse(str, options) : 
        try_without(DateTime, :parse, str)
    end

    def [](era_name_or_date_or_time)
      era_group[era_name_or_date_or_time]
    end

    def try_without(obj, method_name, *args, &block)
      without_m = "#{method_name}_without_warekky"
      return obj.send(without_m, *args, &block) if obj.respond_to?(without_m)
      obj.send(method_name, *args, &block)
    end
  end

end

Warekky::CoreExt.setup
