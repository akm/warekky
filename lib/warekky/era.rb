require 'warekky'

module Warekky
  class Era
    attr_reader :key, :sign, :first, :last, :options
    def initialize(key, sign, first, last, options = {})
      @key, @sign = key.to_sym, sign.to_s.freeze
      @first, @last = to_date(first), to_date(last)
      @options = (options || {}).freeze
    end

    def name
      key.to_s
    end

    def match?(d)
      d = to_date(d)
      (@first ? @first <= d : true) && (@last ? @last >= d : true)
    end

    def [](option_key)
      @options[option_key]
    end

    private
    def to_date(obj)
      return nil unless obj
      return obj if obj.is_a?(Date)
      return Date.new(obj.year, obj.month, obj.day) if obj.is_a?(Time)
      return obj.to_date if respond_to?(:to_date)
      Date.parse(obj.to_s)
    end
  end
end
