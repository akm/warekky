# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe "Warekky" do

  before :all do
    Warekky.era_group_class = Warekky::Ja
  end

  describe :strftime do
    it "without era name (元号の指定なし)" do
      Date.new(1867,12,31).strftime('%Y.%m.%d').should == "1867.12.31"
      Date.new(1868, 1, 1).strftime('%Y.%m.%d').should == "1868.01.01"
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      fmt = '%g%n/%m/%d'
      Date.new(1867,12,31).strftime(fmt).should == "1867/12/31"
      Date.new(1868, 1, 1).strftime(fmt).should == "M01/01/01"
      Date.new(1912, 7,29).strftime(fmt).should == "M45/07/29"
      Date.new(1912, 7,30).strftime(fmt).should == "T01/07/30"
      Date.new(1926,12,24).strftime(fmt).should == "T15/12/24"
      Date.new(1926,12,25).strftime(fmt).should == "S01/12/25"
      Date.new(1989, 1, 7).strftime(fmt).should == "S64/01/07"
      Date.new(1989, 1, 8).strftime(fmt).should == "H01/01/08"
      Date.new(2010, 6, 9).strftime(fmt).should == "H22/06/09"
      Date.new(2050,12,31).strftime(fmt).should == "H62/12/31"
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      fmt = '%G%n/%m/%d'
      Date.new(1867,12,31).strftime(fmt).should == "1867/12/31"
      Date.new(1868, 1, 1).strftime(fmt).should == "明治01/01/01"
      Date.new(1912, 7,29).strftime(fmt).should == "明治45/07/29"
      Date.new(1912, 7,30).strftime(fmt).should == "大正01/07/30"
      Date.new(1926,12,24).strftime(fmt).should == "大正15/12/24"
      Date.new(1926,12,25).strftime(fmt).should == "昭和01/12/25"
      Date.new(1989, 1, 7).strftime(fmt).should == "昭和64/01/07"
      Date.new(1989, 1, 8).strftime(fmt).should == "平成01/01/08"
      Date.new(2010, 6, 9).strftime(fmt).should == "平成22/06/09"
      Date.new(2050,12,31).strftime(fmt).should == "平成62/12/31"
    end
  end

  describe :parse do
    it "without era name (元号の指定なし)" do
      Date.parse("1867/12/31").should == Date.new(1867,12,31)
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      Date.parse("M01/01/01").should == Date.new(1868, 1, 1)
      Date.parse("M45/07/29").should == Date.new(1912, 7,29)
      Date.parse("T01/07/30").should == Date.new(1912, 7,30)
      Date.parse("T15/12/24").should == Date.new(1926,12,24)
      Date.parse("S01/12/25").should == Date.new(1926,12,25)
      Date.parse("S64/01/07").should == Date.new(1989, 1, 7)
      Date.parse("H01/01/08").should == Date.new(1989, 1, 8)
      Date.parse("H22/06/09").should == Date.new(2010, 6, 9)
      Date.parse("H62/12/31").should == Date.new(2050,12,31)
    end

    it "区切りなし" do
      Date.parse("M010101").should == Date.new(1868, 1, 1)
      Date.parse("M450729").should == Date.new(1912, 7,29)
      Date.parse("T010730").should == Date.new(1912, 7,30)
      Date.parse("T151224").should == Date.new(1926,12,24)
      Date.parse("S011225").should == Date.new(1926,12,25)
      Date.parse("S640107").should == Date.new(1989, 1, 7)
      Date.parse("H010108").should == Date.new(1989, 1, 8)
      Date.parse("H220609").should == Date.new(2010, 6, 9)
      Date.parse("H621231").should == Date.new(2050,12,31)
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      Date.parse("明治元年1月1日").should == Date.new(1868, 1, 1)
      Date.parse("明治1年1月1日").should == Date.new(1868, 1, 1)
      Date.parse("明治01年01月01日").should == Date.new(1868, 1, 1)
      Date.parse("明治45年07月29日").should == Date.new(1912, 7,29)
      Date.parse("大正01年07月30日").should == Date.new(1912, 7,30)
      Date.parse("大正15年12月24日").should == Date.new(1926,12,24)
      Date.parse("昭和01年12月25日").should == Date.new(1926,12,25)
      Date.parse("昭和64年01月07日").should == Date.new(1989, 1, 7)
      Date.parse("平成01年01月08日").should == Date.new(1989, 1, 8)
      Date.parse("平成22年06月09日").should == Date.new(2010, 6, 9)
      Date.parse("平成62年12月31日").should == Date.new(2050,12,31)
    end

    it "with chinese charactor short era name (漢字省略表記の元号)" do
      Date.parse("明元年1月1日").should == Date.new(1868, 1, 1)
      Date.parse("明1年1月1日").should == Date.new(1868, 1, 1)
      Date.parse("明01年01月01日").should == Date.new(1868, 1, 1)
      Date.parse("明45年07月29日").should == Date.new(1912, 7,29)
      Date.parse("大01年07月30日").should == Date.new(1912, 7,30)
      Date.parse("大15年12月24日").should == Date.new(1926,12,24)
      Date.parse("昭01年12月25日").should == Date.new(1926,12,25)
      Date.parse("昭64年01月07日").should == Date.new(1989, 1, 7)
      Date.parse("平01年01月08日").should == Date.new(1989, 1, 8)
      Date.parse("平22年06月09日").should == Date.new(2010, 6, 9)
      Date.parse("平62年12月31日").should == Date.new(2050,12,31)
    end

  end

  describe :[] do
    describe "should return an Era object" do
      it "for era_name" do
        [:meiji, :taisho, :showa, :heisei].each do |era|
          Date.eras[era].class.should == Warekky::Era
          Date.eras[era.to_s].class.should == Warekky::Era
        end
        Date.eras[nil].should == nil
        Date.eras[''].should == nil
        Date.eras[:unexist_era].should == nil
      end

      it "for era_name with kanji" do
        %w[M T S H 明治 大正 昭和 平成 明 大 昭 平].each do |era|
          Date.eras[era].class.should == Warekky::Era
        end
      end

      it "for date" do
        Date.eras[Date.new(1867,12,31)].should == nil
        Date.eras[Date.new(1868, 1, 1)].name.should == 'meiji'
        Date.eras[Date.new(1912, 7,29)].name.should == 'meiji'
        Date.eras[Date.new(1912, 7,30)].name.should == 'taisho'
        Date.eras[Date.new(1926,12,24)].name.should == 'taisho'
        Date.eras[Date.new(1926,12,25)].name.should == 'showa'
        Date.eras[Date.new(1989, 1, 7)].name.should == 'showa'
        Date.eras[Date.new(1989, 1, 8)].name.should == 'heisei'
        Date.eras[Date.new(2010, 6, 9)].name.should == 'heisei'
        Date.eras[Date.new(2050,12,31)].name.should == 'heisei'
      end
    end
  end
end
