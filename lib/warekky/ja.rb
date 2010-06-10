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
# 1868/01/01, 1912/07/29 明治 # グレゴリオ暦では 1868/1/25 から明治元年。
#	1912/07/30, 1926/12/24 大正
#	1926/12/25, 1989/01/07 昭和
#	1989/01/08,	---------- 平成

module Warekky
  class Ja < EraGroup
    era_extra_names :long, :short

    regexp do |era|
      Regexp.union(
        /(#{era.name})(\d{1,2})/,
        /(#{era[:short]})(\d{1,2})/,
        /(#{era[:long]})(\d{1,2})/)
    end
    
    era('1868/01/01', '1912/07/29', :meiji , 'M', :long => '明治', :short => "明")
    era('1912/07/30', '1926/12/24', :taisho, 'T', :long => '大正', :short => "大")
    era('1926/12/25', '1989/01/07', :showa , 'S', :long => '昭和', :short => "昭")
    era('1989/01/08', nil					, :heisei, 'H', :long => '平成', :short => "平")

    DEFAULT_REPLACEMENTS_BEFORE_PARSE = { 
      "元年" => "1年"
    }.freeze

    attr_accessor :replacements_before_parse

    def initialize
      @replacements_before_parse = DEFAULT_REPLACEMENTS_BEFORE_PARSE.dup
    end

    def parse(str, options = {})
      dic = replacements_before_parse
      str.gsub(replacements_regexp_before_parse){|s| dic[s]}
      era_dic = name_to_era
      era_replacements = Regexp.union(eras.map(&self.class.regexp_builder))
      str.gsub(era_replacements){|s, y| era_dic[y]}
    end

    private

    def replacements_regexp_before_parse
      @replacements_regexp_before_parse ||= 
        Regexp.union(*replacements_before_parse.keys.map{|s| /(#{Regexp.escape(s)})/})
    end

  end
end
