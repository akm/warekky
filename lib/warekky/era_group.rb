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
    def replacements_before_parse
      self.class.replacements_before_parse
    end

    def parse(str, options = {})
      str = str.dup
      replacements_before_parse.each_with_index do |dic, idx|
        str.gsub!(replacements_regexp_before_parse[idx]){|s| dic[s]}
      end
      era_dic = name_to_era
      str.gsub!(era_replacements) do
        md = Regexp.last_match
        h = Hash[*md.captures]
        h.delete(nil)
        s = h.keys.first
        era = era_dic[s]
        raise ArgumentError, "Era not found for #{s.inspect}" unless era
        era.to_ad_year(h[s]).to_s
      end
      Date.parse(str)
    end

    def strftime(d, format)
      return d.strftime(format) unless formats_regexp.match(format)
      era = self[d]
      era_year = era ? era.to_era_year(d.year) : d.year
      format = format.dup
      format.gsub!(formats_regexp) do
        md = Regexp.last_match
        s = md.captures.compact.first
        rep = formats[s]
        raise ArgumentError, "replacement not found for #{s.inspect}" unless rep
        res = rep.call(era, era_year)
        res
      end
      d.strftime(format)
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

    def replacements_regexp_before_parse
      @replacements_regexp_before_parse ||=
        replacements_before_parse.map{|replacements|
        Regexp.union(*replacements.keys.map{|s| /(#{Regexp.escape(s)})/})}
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

      def era(first, last, key, sign, options = {})
        key = key.to_sym
        result = Era.new(key, sign, first, last, options).freeze
        eras << result
        result
      end

      def era_extra_names
        eras.map{|era| era.options.keys}.flatten.uniq
      end

      attr_accessor :parse_regexp_builder
      def parse_regexp(&block)
        @parse_regexp_builder = block
      end

      def replacements_before_parse
        @replacements_before_parse ||= []
      end

      def replace_before_parse(*replacements)
        @replacements_before_parse = replacements
      end

      def era_replacements
        @era_replacements ||= Regexp.union(eras.map(&parse_regexp_builder).flatten)
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
