# -*- coding: utf-8 -*-
require 'warekky'

# http://ja.wikipedia.org/wiki/明治
#		明治（めいじ）は、日本の元号の一つ。慶応の後、大正の前。明治元年1月1日（1868年1月25日）から
#		明治45年（大正元年、1912年）7月30日までの期間を指す。明治天皇在位期間とほぼ一致する。
#		ただし、実際に改元の詔書が出されたのは慶応4年9月8日（1868年10月23日）で、同年1月1日に遡って明治元年とすると定めた。
#
#		※明治5年までは旧暦を使用していたため、西暦（グレゴリオ暦）の年とは厳密には一致しない。詳細は明治元年〜5年の各年の項目を参照。
#
# http://ja.wikipedia.org/wiki/一世一元の詔
#		一世一元の詔（いっせいいちげんのみことのり）は、慶応4年9月8日（グレゴリオ暦1868年10月23日）、
#		慶応4年を改めて明治元年とするとともに、天皇一代に元号一つという一世一元の制を定めた詔。明治改元の詔ともいう。
#
# 1868/01/01, 1912/07/29 明治 - 45 # グレゴリオ暦では 1868/1/25 から明治元年。
#	1912/07/30, 1926/12/24 大正 - 15
#	1926/12/25, 1989/01/07 昭和 - 64
#	1989/01/08,	---------- 平成

module Warekky
  class Ja < EraGroup
    era_extra_names :long, :short

    regexp do |era|
      [ /(#{Regexp.escape(era.name)})(\d{1,2})/,
				/(#{Regexp.escape(era.sign)})(\d{1,2})/,
				/(#{Regexp.escape(era[:short])})(\d{1,2})/,
				/(#{Regexp.escape(era[:long])})(\d{1,2})/]
    end

		format('%G'){|era, era_year| era[:long] if era}
    format('%g'){|era, era_year| era.sign if era}
		format('%n'){|era, era_year| '%02d' % era_year}

    era('1868/01/01', '1912/07/29', :meiji , 'M', :long => '明治', :short => "明")
    era('1912/07/30', '1926/12/24', :taisho, 'T', :long => '大正', :short => "大")
    era('1926/12/25', '1989/01/07', :showa , 'S', :long => '昭和', :short => "昭")
    era('1989/01/08', nil					, :heisei, 'H', :long => '平成', :short => "平")

    DEFAULT_REPLACEMENTS_BEFORE_PARSE = [
      {"元年" => "1年"}.freeze,
      {"年" => ".", "月" => ".", "日" => ""}.freeze
    ].freeze


    attr_accessor :replacements_before_parse

    def initialize
      @replacements_before_parse = DEFAULT_REPLACEMENTS_BEFORE_PARSE.map{|hash| hash.dup}
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

    private

    def replacements_regexp_before_parse
      @replacements_regexp_before_parse ||=
        replacements_before_parse.map{|replacements|
        Regexp.union(*replacements.keys.map{|s| /(#{Regexp.escape(s)})/})}
    end

  end
end
