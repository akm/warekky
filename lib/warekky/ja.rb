# -*- coding: utf-8 -*-
require 'warekky'

module Warekky
  class Ja < EraGroup
    # http://ja.wikipedia.org/wiki/明治
    #		明治（めいじ）は、日本の元号の一つ。慶応の後、大正の前。明治元年1月1日（1868年1月25日）から
    #		明治45年（大正元年、1912年）7月30日までの期間を指す。明治天皇在位期間とほぼ一致する。
    #		ただし、実際に改元の詔書が出されたのは慶応4年9月8日（1868年10月23日）で、同年1月1日に遡って明治元年とすると定めた。
    #
    #		※明治5年までは旧暦を使用していたため、西暦（グレゴリオ暦）の年とは厳密には一致しない。詳細は明治元年〜5年の各年の項目を参照。
    era('1868/01/01', '1912/07/29', :meiji , 'M', :long => '明治', :short => "明") # 1 - 45
    era('1912/07/30', '1926/12/24', :taisho, 'T', :long => '大正', :short => "大") # 1 - 15
    era('1926/12/25', '1989/01/07', :showa , 'S', :long => '昭和', :short => "昭") # 1 - 64
    era('1989/01/08', nil					, :heisei, 'H', :long => '平成', :short => "平") # 1 -

    # strftimeで使える記号
		format('%G'){|era, era_year| era[:long] if era} # 明治/大正/昭和/平成
    format('%g'){|era, era_year| era.sign if era}   # M/T/S/H
		format('%n'){|era, era_year| '%02d' % era_year} # (元号での)年度

    # parseで使われる元号毎の正規表現
    parse_regexp do |era|
      [ /(#{Regexp.escape(era.name)})(\d{1,2})/,
				/(#{Regexp.escape(era.sign)})(\d{1,2})/,
				/(#{Regexp.escape(era[:short])})(\d{1,2})/,
				/(#{Regexp.escape(era[:long])})(\d{1,2})/]
    end

    # parseを実行前に適用される置換
    replace_before_parse(
      {"元年" => "1年"},
      {"年" => ".", "月" => ".", "日" => "", "時" => ":", "分" => ":", "秒" => ""}
      )
  end
end
