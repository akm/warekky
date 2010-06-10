# -*- coding: utf-8 -*-
require 'warekky'

module Warekky
  class EraGroup
    def initialize
      @formats = self.class.formats.dup
    end

    def eras
      self.class.eras
    end
    def name_to_era
      self.class.name_to_era
    end
    def era_replacements
      self.class.era_replacements
    end
    def formats
      self.class.formats
    end
    def formats_regexp
      self.class.formats_regexp
    end

    def era_extra_names
      # インスタンスでは変更できないようにするので、引数を渡しません
      self.class.era_extra_names
    end

    def strftime(d, format = {})
      raise NotImplementedError, "#{self.class.name}#strftime is not implemented."
    end

    def parse(str, options = {})
      raise NotImplementedError, "#{self.class.name}#parse is not implemented."
    end

    def [](era_name_or_date_or_time)
      return nil unless era_name_or_date_or_time
      case era_name_or_date_or_time
      when Symbol, String then
        name_to_era[era_name_or_date_or_time]
      when Time, Date then
        eras.detect{|era| era.match?(era_name_or_date_or_time)}
      else
        raise ArgumentError, "#{self.class.name}#[] doesn't support #{era_name_or_date_or_time.inspect}"
      end
    end

    class << self
      def eras
        @eras ||= []
      end
      def name_to_era
        unless @name_to_era
          @name_to_era = eras.inject({}) do |d, era|
            d[era.key] = era
            d[era.key.to_s] = era
            d[era.sign] = era
            era_extra_names.each do |extra_name|
              d[era[extra_name]] = era
            end
            d
          end
        end
        @name_to_era
      end

      def era_extra_names(*args)
        @era_extra_names = args unless args.empty?
        @era_extra_names ||= []
      end

      def era(first, last, key, sign, options = {})
        key = key.to_sym
        result = Era.new(key, sign, first, last, options).freeze
        eras << result
        result
      end

      attr_accessor :regexp_builder
      def regexp(&block)
        @regexp_builder = block
      end

      def era_replacements
        @era_replacements ||= Regexp.union(eras.map(&regexp_builder).flatten)
      end

      def formats
        @formats ||= {}
      end

      def format(pattern, &block)
        formats[pattern] = block
      end

      def formats_regexp
        @formats_regexp ||=
          Regexp.union(*formats.map{|(k,v)| /(#{Regexp.escape(k)})/})
      end

    end

  end
end
