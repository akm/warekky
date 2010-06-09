# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Warekky" do
  
  # http://ja.wikipedia.org/wiki/明治
  #   明治（めいじ）は、日本の元号の一つ。慶応の後、大正の前。明治元年1月1日（1868年1月25日）から
  #   明治45年（大正元年、1912年）7月30日までの期間を指す。明治天皇在位期間とほぼ一致する。
  #   ただし、実際に改元の詔書が出されたのは慶応4年9月8日（1868年10月23日）で、同年1月1日に遡って明治元年とすると定めた。
  #
  #   ※明治5年までは旧暦を使用していたため、西暦（グレゴリオ暦）の年とは厳密には一致しない。詳細は明治元年〜5年の各年の項目を参照。
  #
  # http://ja.wikipedia.org/wiki/一世一元の詔
  #   一世一元の詔（いっせいいちげんのみことのり）は、慶応4年9月8日（グレゴリオ暦1868年10月23日）、
  #   慶応4年を改めて明治元年とするとともに、天皇一代に元号一つという一世一元の制を定めた詔。明治改元の詔ともいう。
  #
	# 1868/01/01, 1912/07/29 明治 # グレゴリオ暦では 1868/1/25 から明治元年。
	#	1912/07/30, 1926/12/24 大正
	#	1926/12/25, 1989/01/07 昭和
	#	1989/01/08,	---------- 平成

  describe :strftime do
    it "without era name (元号の指定なし)" do
      Warekky.strftime(Date.new(1867,12,31), '%y.%m.%d').should == "1867.12.31"
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      fmt = '%g%n/%m/%d'
      Warekky.strftime(Date.new(1867,12,31), fmt).should == "1867/01/01"
      Warekky.strftime(Date.new(1868, 1, 1), fmt).should == "M01/01/01"
			Warekky.strftime(Date.new(1912, 7,29), fmt).should == "M45/07/29"
			Warekky.strftime(Date.new(1912, 7,30), fmt).should == "T01/07/30"
			Warekky.strftime(Date.new(1926,12,24), fmt).should == "T15/12/24"
			Warekky.strftime(Date.new(1926,12,25), fmt).should == "S01/12/25"
			Warekky.strftime(Date.new(1989, 1, 7), fmt).should == "S64/01/07"
			Warekky.strftime(Date.new(1989, 1, 8), fmt).should == "H01/01/08"
			Warekky.strftime(Date.new(2010, 6, 9), fmt).should == "H22/06/09"
			Warekky.strftime(Date.new(2050,12,31), fmt).should == "H62/12/31"
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      fmt = '%G%n/%m/%d'
      Warekky.strftime(Date.new(1867,12,31), fmt).should == "1867/01/01"
			Warekky.strftime(Date.new(1868, 1, 1), fmt).should == "明治01/01/01"
			Warekky.strftime(Date.new(1912, 7,29), fmt).should == "明治45/07/29"
			Warekky.strftime(Date.new(1912, 7,30), fmt).should == "大正01/07/30"
			Warekky.strftime(Date.new(1926,12,24), fmt).should == "大正15/12/24"
			Warekky.strftime(Date.new(1926,12,25), fmt).should == "昭和01/12/25"
			Warekky.strftime(Date.new(1989, 1, 7), fmt).should == "昭和64/01/07"
			Warekky.strftime(Date.new(1989, 1, 8), fmt).should == "平成01/01/08"
			Warekky.strftime(Date.new(2010, 6, 9), fmt).should == "平成22/06/09"
			Warekky.strftime(Date.new(2050,12,31), fmt).should == "平成62/12/31"
    end
  end

  describe :parse do
    it "without era name (元号の指定なし)" do
      Warekky.parse("1867/12/31").should == Date.new(1867,12,31)
    end

    it "with alphabet era name (アルファベット表記の元号)" do
			Warekky.parse("M01/01/01").should == Date.new(1868, 1, 1)
			Warekky.parse("M45/07/29").should == Date.new(1912, 7,29)
			Warekky.parse("T01/07/30").should == Date.new(1912, 7,30)
			Warekky.parse("T15/12/24").should == Date.new(1926,12,24)
			Warekky.parse("S01/12/25").should == Date.new(1926,12,25)
			Warekky.parse("S64/01/07").should == Date.new(1989, 1, 7)
			Warekky.parse("H01/01/08").should == Date.new(1989, 1, 8)
			Warekky.parse("H22/06/09").should == Date.new(2010, 6, 9)
			Warekky.parse("H62/12/31").should == Date.new(2050,12,31)
    end
    
    it "with chinese charactor era name (漢字表記の元号)" do
			Warekky.parse("明治元年1月1日").should ==Date.new(1868, 1, 1)
			Warekky.parse("明治1年1月1日").should ==Date.new(1868, 1, 1)
			Warekky.parse("明治01年01月01日").should ==Date.new(1868, 1, 1)
			Warekky.parse("明治45年07月29日").should ==Date.new(1912, 7,29)
			Warekky.parse("大正01年07月30日").should ==Date.new(1912, 7,30)
			Warekky.parse("大正15年12月24日").should ==Date.new(1926,12,24)
			Warekky.parse("昭和01年12月25日").should ==Date.new(1926,12,25)
			Warekky.parse("昭和64年01月07日").should ==Date.new(1989, 1, 7)
			Warekky.parse("平成01年01月08日").should ==Date.new(1989, 1, 8)
			Warekky.parse("平成22年06月09日").should ==Date.new(2010, 6, 9)
			Warekky.parse("平成62年12月31日").should ==Date.new(2050,12,31)
    end

    it "with chinese charactor short era name (漢字省略表記の元号)" do
			Warekky.parse("明元年1月1日").should ==Date.new(1868, 1, 1)
			Warekky.parse("明1年1月1日").should ==Date.new(1868, 1, 1)
			Warekky.parse("明01年01月01日").should ==Date.new(1868, 1, 1)
			Warekky.parse("明45年07月29日").should ==Date.new(1912, 7,29)
			Warekky.parse("大01年07月30日").should ==Date.new(1912, 7,30)
			Warekky.parse("大15年12月24日").should ==Date.new(1926,12,24)
			Warekky.parse("昭01年12月25日").should ==Date.new(1926,12,25)
			Warekky.parse("昭64年01月07日").should ==Date.new(1989, 1, 7)
			Warekky.parse("平01年01月08日").should ==Date.new(1989, 1, 8)
			Warekky.parse("平22年06月09日").should ==Date.new(2010, 6, 9)
			Warekky.parse("平62年12月31日").should ==Date.new(2050,12,31)
    end

  end

  describe :[] do
    it "should return an Era object" do
      [:meiji, :taisho, :showa, :heisei].each do |era|
        Warekky[era].class.should == Warekky::Era
        Warekky[era.to_s].class.should == Warekky::Era
      end
      Warekky[:unexist_era].should == nil
    end
  end
end
