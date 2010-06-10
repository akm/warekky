# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe "Warekky" do

  before :all do
    Warekky.era_group_class = Warekky::Ja
  end

  describe :strftime do
    it "without era name (元号の指定なし)" do
      DateTime.new(1867,12,31).strftime('%Y.%m.%d').should == "1867.12.31"
      DateTime.new(1868, 1, 1).strftime('%Y.%m.%d').should == "1868.01.01"
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      fmt = '%g%n/%m/%d'
      DateTime.new(1867,12,31).strftime(fmt).should == "1867/12/31"
      DateTime.new(1868, 1, 1).strftime(fmt).should == "M01/01/01"
      DateTime.new(1912, 7,29).strftime(fmt).should == "M45/07/29"
      DateTime.new(1912, 7,30).strftime(fmt).should == "T01/07/30"
      DateTime.new(1926,12,24).strftime(fmt).should == "T15/12/24"
      DateTime.new(1926,12,25).strftime(fmt).should == "S01/12/25"
      DateTime.new(1989, 1, 7).strftime(fmt).should == "S64/01/07"
      DateTime.new(1989, 1, 8).strftime(fmt).should == "H01/01/08"
      DateTime.new(2010, 6, 9).strftime(fmt).should == "H22/06/09"
      DateTime.new(2050,12,31).strftime(fmt).should == "H62/12/31"
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      fmt = '%G%n/%m/%d'
      DateTime.new(1867,12,31).strftime(fmt).should == "1867/12/31"
      DateTime.new(1868, 1, 1).strftime(fmt).should == "明治01/01/01"
      DateTime.new(1912, 7,29).strftime(fmt).should == "明治45/07/29"
      DateTime.new(1912, 7,30).strftime(fmt).should == "大正01/07/30"
      DateTime.new(1926,12,24).strftime(fmt).should == "大正15/12/24"
      DateTime.new(1926,12,25).strftime(fmt).should == "昭和01/12/25"
      DateTime.new(1989, 1, 7).strftime(fmt).should == "昭和64/01/07"
      DateTime.new(1989, 1, 8).strftime(fmt).should == "平成01/01/08"
      DateTime.new(2010, 6, 9).strftime(fmt).should == "平成22/06/09"
      DateTime.new(2050,12,31).strftime(fmt).should == "平成62/12/31"
    end
  end


  describe :era do
    it "should return an era for date" do
      DateTime.new(1867,12,31).era.should == nil
      DateTime.new(1868, 1, 1).era.name.should == 'meiji'
      DateTime.new(1912, 7,29).era.name.should == 'meiji'
      DateTime.new(1912, 7,30).era.name.should == 'taisho'
      DateTime.new(1926,12,24).era.name.should == 'taisho'
      DateTime.new(1926,12,25).era.name.should == 'showa'
      DateTime.new(1989, 1, 7).era.name.should == 'showa'
      DateTime.new(1989, 1, 8).era.name.should == 'heisei'
      DateTime.new(2010, 6, 9).era.name.should == 'heisei'
      DateTime.new(2050,12,31).era.name.should == 'heisei'
    end
  end

  describe :parse do
    it "without era name (元号の指定なし)" do
      DateTime.parse("1867/12/31").should == DateTime.new(1867,12,31)
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      DateTime.parse("M01/01/01").should == DateTime.new(1868, 1, 1)
      DateTime.parse("M45/07/29").should == DateTime.new(1912, 7,29)
      DateTime.parse("T01/07/30").should == DateTime.new(1912, 7,30)
      DateTime.parse("T15/12/24").should == DateTime.new(1926,12,24)
      DateTime.parse("S01/12/25").should == DateTime.new(1926,12,25)
      DateTime.parse("S64/01/07").should == DateTime.new(1989, 1, 7)
      DateTime.parse("H01/01/08").should == DateTime.new(1989, 1, 8)
      DateTime.parse("H22/06/09").should == DateTime.new(2010, 6, 9)
      DateTime.parse("H62/12/31").should == DateTime.new(2050,12,31)
      DateTime.parse("H22/06/09 01:23:45").should == DateTime.new(2010, 6, 9, 1, 23, 45)
    end

    it "区切りなし" do
      DateTime.parse("M010101").should == DateTime.new(1868, 1, 1)
      DateTime.parse("M450729").should == DateTime.new(1912, 7,29)
      DateTime.parse("T010730").should == DateTime.new(1912, 7,30)
      DateTime.parse("T151224").should == DateTime.new(1926,12,24)
      DateTime.parse("S011225").should == DateTime.new(1926,12,25)
      DateTime.parse("S640107").should == DateTime.new(1989, 1, 7)
      DateTime.parse("H010108").should == DateTime.new(1989, 1, 8)
      DateTime.parse("H220609").should == DateTime.new(2010, 6, 9)
      DateTime.parse("H621231").should == DateTime.new(2050,12,31)
      DateTime.parse("H220609 012345").should == DateTime.new(2010, 6, 9, 1, 23, 45)
      DateTime.parse("H220609012345").should == DateTime.new(2010, 6, 9, 1, 23, 45)
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      DateTime.parse("明治元年1月1日").should == DateTime.new(1868, 1, 1)
      DateTime.parse("明治1年1月1日").should == DateTime.new(1868, 1, 1)
      DateTime.parse("明治01年01月01日").should == DateTime.new(1868, 1, 1)
      DateTime.parse("明治45年07月29日").should == DateTime.new(1912, 7,29)
      DateTime.parse("大正01年07月30日").should == DateTime.new(1912, 7,30)
      DateTime.parse("大正15年12月24日").should == DateTime.new(1926,12,24)
      DateTime.parse("昭和01年12月25日").should == DateTime.new(1926,12,25)
      DateTime.parse("昭和64年01月07日").should == DateTime.new(1989, 1, 7)
      DateTime.parse("平成01年01月08日").should == DateTime.new(1989, 1, 8)
      DateTime.parse("平成22年06月09日").should == DateTime.new(2010, 6, 9)
      DateTime.parse("平成62年12月31日").should == DateTime.new(2050,12,31)
      DateTime.parse("平成22年06月09日 12時34分56秒").should == DateTime.new(2010, 6, 9, 12, 34, 56)
    end

    it "with chinese charactor short era name (漢字省略表記の元号)" do
      DateTime.parse("明元年1月1日").should == DateTime.new(1868, 1, 1)
      DateTime.parse("明1年1月1日").should == DateTime.new(1868, 1, 1)
      DateTime.parse("明01年01月01日").should == DateTime.new(1868, 1, 1)
      DateTime.parse("明45年07月29日").should == DateTime.new(1912, 7,29)
      DateTime.parse("大01年07月30日").should == DateTime.new(1912, 7,30)
      DateTime.parse("大15年12月24日").should == DateTime.new(1926,12,24)
      DateTime.parse("昭01年12月25日").should == DateTime.new(1926,12,25)
      DateTime.parse("昭64年01月07日").should == DateTime.new(1989, 1, 7)
      DateTime.parse("平01年01月08日").should == DateTime.new(1989, 1, 8)
      DateTime.parse("平22年06月09日").should == DateTime.new(2010, 6, 9)
      DateTime.parse("平62年12月31日").should == DateTime.new(2050,12,31)
    end

  end

  describe :[] do
    describe "should return an Era object" do
      it "for era_name" do
        [:meiji, :taisho, :showa, :heisei].each do |era|
          DateTime.eras[era].class.should == Warekky::Era
          DateTime.eras[era.to_s].class.should == Warekky::Era
        end
        DateTime.eras[nil].should == nil
        DateTime.eras[''].should == nil
        DateTime.eras[:unexist_era].should == nil
      end

      it "for era_name with kanji" do
        %w[M T S H 明治 大正 昭和 平成 明 大 昭 平].each do |era|
          DateTime.eras[era].class.should == Warekky::Era
        end
      end

      it "for date" do
        DateTime.eras[DateTime.new(1867,12,31)].should == nil
        DateTime.eras[DateTime.new(1868, 1, 1)].name.should == 'meiji'
        DateTime.eras[DateTime.new(1912, 7,29)].name.should == 'meiji'
        DateTime.eras[DateTime.new(1912, 7,30)].name.should == 'taisho'
        DateTime.eras[DateTime.new(1926,12,24)].name.should == 'taisho'
        DateTime.eras[DateTime.new(1926,12,25)].name.should == 'showa'
        DateTime.eras[DateTime.new(1989, 1, 7)].name.should == 'showa'
        DateTime.eras[DateTime.new(1989, 1, 8)].name.should == 'heisei'
        DateTime.eras[DateTime.new(2010, 6, 9)].name.should == 'heisei'
        DateTime.eras[DateTime.new(2050,12,31)].name.should == 'heisei'
      end
    end
  end
end
