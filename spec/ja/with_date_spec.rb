# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe "Warekky" do

  before :all do
    Warekky.era_group_class = Warekky::Ja
  end

  describe :strftime do
    it "without era name (元号の指定なし)" do
      Warekky.strftime(Date.new(1867,12,31), '%Y.%m.%d').should == "1867.12.31"
      Warekky.strftime(Date.new(1868, 1, 1), '%Y.%m.%d').should == "1868.01.01"
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      fmt = '%g%n/%m/%d'
      Warekky.strftime(Date.new(1867,12,31), fmt).should == "1867/12/31"
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
      Warekky.strftime(Date.new(1867,12,31), fmt).should == "1867/12/31"
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

    context "区切りなし" do
      it "by Time.parse" do
        Date.parse("18671231").should == Date.new(1867, 12, 31)
      end

      it "by Warekky.parse" do
        Warekky.parse("M010101", :class => Date).should == Date.new(1868, 1, 1)
				Warekky.parse("M450729", :class => Date).should == Date.new(1912, 7,29)
				Warekky.parse("T010730", :class => Date).should == Date.new(1912, 7,30)
				Warekky.parse("T151224", :class => Date).should == Date.new(1926,12,24)
				Warekky.parse("S011225", :class => Date).should == Date.new(1926,12,25)
				Warekky.parse("S640107", :class => Date).should == Date.new(1989, 1, 7)
				Warekky.parse("H010108", :class => Date).should == Date.new(1989, 1, 8)
				Warekky.parse("H220609", :class => Date).should == Date.new(2010, 6, 9)
				Warekky.parse("H621231", :class => Date).should == Date.new(2050,12,31)
      end
    end

    it "with chinese charactor era name (漢字表記の元号)" do
			Warekky.parse("明治元年1月1日").should == Date.new(1868, 1, 1)
			Warekky.parse("明治1年1月1日").should == Date.new(1868, 1, 1)
			Warekky.parse("明治01年01月01日").should == Date.new(1868, 1, 1)
			Warekky.parse("明治45年07月29日").should == Date.new(1912, 7,29)
			Warekky.parse("大正01年07月30日").should == Date.new(1912, 7,30)
			Warekky.parse("大正15年12月24日").should == Date.new(1926,12,24)
			Warekky.parse("昭和01年12月25日").should == Date.new(1926,12,25)
			Warekky.parse("昭和64年01月07日").should == Date.new(1989, 1, 7)
			Warekky.parse("平成01年01月08日").should == Date.new(1989, 1, 8)
			Warekky.parse("平成22年06月09日").should == Date.new(2010, 6, 9)
			Warekky.parse("平成62年12月31日").should == Date.new(2050,12,31)
    end

    it "with chinese charactor short era name (漢字省略表記の元号)" do
			Warekky.parse("明元年1月1日").should == Date.new(1868, 1, 1)
			Warekky.parse("明1年1月1日").should == Date.new(1868, 1, 1)
			Warekky.parse("明01年01月01日").should == Date.new(1868, 1, 1)
			Warekky.parse("明45年07月29日").should == Date.new(1912, 7,29)
			Warekky.parse("大01年07月30日").should == Date.new(1912, 7,30)
			Warekky.parse("大15年12月24日").should == Date.new(1926,12,24)
			Warekky.parse("昭01年12月25日").should == Date.new(1926,12,25)
			Warekky.parse("昭64年01月07日").should == Date.new(1989, 1, 7)
			Warekky.parse("平01年01月08日").should == Date.new(1989, 1, 8)
			Warekky.parse("平22年06月09日").should == Date.new(2010, 6, 9)
			Warekky.parse("平62年12月31日").should == Date.new(2050,12,31)
    end

  end

  describe :[] do
    describe "should return an Era object" do
      it "for era_name" do
        [:meiji, :taisho, :showa, :heisei].each do |era|
          Warekky[era].class.should == Warekky::Era
          Warekky[era.to_s].class.should == Warekky::Era
        end
        Warekky[nil].should == nil
        Warekky[''].should == nil
        Warekky[:unexist_era].should == nil
      end

      it "for era_name with kanji" do
        %w[M T S H 明治 大正 昭和 平成 明 大 昭 平].each do |era|
          Warekky[era].class.should == Warekky::Era
        end
      end

      it "for date" do
        Warekky[Date.new(1867,12,31)].should == nil
        Warekky[Date.new(1868, 1, 1)].name.should == 'meiji'
        Warekky[Date.new(1912, 7,29)].name.should == 'meiji'
        Warekky[Date.new(1912, 7,30)].name.should == 'taisho'
        Warekky[Date.new(1926,12,24)].name.should == 'taisho'
        Warekky[Date.new(1926,12,25)].name.should == 'showa'
        Warekky[Date.new(1989, 1, 7)].name.should == 'showa'
        Warekky[Date.new(1989, 1, 8)].name.should == 'heisei'
        Warekky[Date.new(2010, 6, 9)].name.should == 'heisei'
        Warekky[Date.new(2050,12,31)].name.should == 'heisei'
      end
    end
  end
end
