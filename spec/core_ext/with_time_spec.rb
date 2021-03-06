# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe "Warekky" do

  before :all do
    Warekky.era_group_class = Warekky::Ja
  end

  describe :strftime do
    it "without era name (元号の指定なし)" do
      Time.local(1867,12,31).strftime('%Y.%m.%d').should == "1867.12.31"
      Time.local(1868, 1, 1).strftime('%Y.%m.%d').should == "1868.01.01"
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      fmt = '%g%N/%m/%d'
      Time.local(1867,12,31).strftime(fmt).should == "1867/12/31"
      Time.local(1868, 1, 1).strftime(fmt).should == "M01/01/01"
      Time.local(1912, 7,29).strftime(fmt).should == "M45/07/29"
      Time.local(1912, 7,30).strftime(fmt).should == "T01/07/30"
      Time.local(1926,12,24).strftime(fmt).should == "T15/12/24"
      Time.local(1926,12,25).strftime(fmt).should == "S01/12/25"
      Time.local(1989, 1, 7).strftime(fmt).should == "S64/01/07"
      Time.local(1989, 1, 8).strftime(fmt).should == "H01/01/08"
      Time.local(2010, 6, 9).strftime(fmt).should == "H22/06/09"
      Time.local(2050,12,31).strftime(fmt).should == "H62/12/31"
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      fmt = '%G%N/%m/%d'
      Time.local(1867,12,31).strftime(fmt).should == "1867/12/31"
      Time.local(1868, 1, 1).strftime(fmt).should == "明治01/01/01"
      Time.local(1912, 7,29).strftime(fmt).should == "明治45/07/29"
      Time.local(1912, 7,30).strftime(fmt).should == "大正01/07/30"
      Time.local(1926,12,24).strftime(fmt).should == "大正15/12/24"
      Time.local(1926,12,25).strftime(fmt).should == "昭和01/12/25"
      Time.local(1989, 1, 7).strftime(fmt).should == "昭和64/01/07"
      Time.local(1989, 1, 8).strftime(fmt).should == "平成01/01/08"
      Time.local(2010, 6, 9).strftime(fmt).should == "平成22/06/09"
      Time.local(2050,12,31).strftime(fmt).should == "平成62/12/31"
    end
  end


  describe :era do
    it "should return an era for date" do
      Time.local(1867,12,31).era.should == nil
      Time.local(1868, 1, 1).era.name.should == 'meiji'
      Time.local(1912, 7,29).era.name.should == 'meiji'
      Time.local(1912, 7,30).era.name.should == 'taisho'
      Time.local(1926,12,24).era.name.should == 'taisho'
      Time.local(1926,12,25).era.name.should == 'showa'
      Time.local(1989, 1, 7).era.name.should == 'showa'
      Time.local(1989, 1, 8).era.name.should == 'heisei'
      Time.local(2010, 6, 9).era.name.should == 'heisei'
      Time.local(2050,12,31).era.name.should == 'heisei'
    end
  end

  describe :parse do
    it "without era name (元号の指定なし)" do
      Time.parse("1867/12/31").should == Time.local(1867,12,31)
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      Time.parse("M01/01/01").should == Time.local(1868, 1, 1)
      Time.parse("M45/07/29").should == Time.local(1912, 7,29)
      Time.parse("T01/07/30").should == Time.local(1912, 7,30)
      Time.parse("T15/12/24").should == Time.local(1926,12,24)
      Time.parse("S01/12/25").should == Time.local(1926,12,25)
      Time.parse("S64/01/07").should == Time.local(1989, 1, 7)
      Time.parse("H01/01/08").should == Time.local(1989, 1, 8)
      Time.parse("H22/06/09").should == Time.local(2010, 6, 9)
      Time.parse("H62/12/31").should == Time.local(2050,12,31)
      Time.parse("H22/06/09 01:23:45").should == Time.local(2010, 6, 9, 1, 23, 45)
    end

    it "区切りなし" do
      Time.parse("M010101").should == Time.local(1868, 1, 1)
      Time.parse("M450729").should == Time.local(1912, 7,29)
      Time.parse("T010730").should == Time.local(1912, 7,30)
      Time.parse("T151224").should == Time.local(1926,12,24)
      Time.parse("S011225").should == Time.local(1926,12,25)
      Time.parse("S640107").should == Time.local(1989, 1, 7)
      Time.parse("H010108").should == Time.local(1989, 1, 8)
      Time.parse("H220609").should == Time.local(2010, 6, 9)
      Time.parse("H621231").should == Time.local(2050,12,31)
      Time.parse("H220609 012345").should == Time.local(2010, 6, 9, 1, 23, 45)
      Time.parse("H220609012345").should == Time.local(2010, 6, 9, 1, 23, 45)
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      Time.parse("明治元年1月1日").should == Time.local(1868, 1, 1)
      Time.parse("明治1年1月1日").should == Time.local(1868, 1, 1)
      Time.parse("明治01年01月01日").should == Time.local(1868, 1, 1)
      Time.parse("明治45年07月29日").should == Time.local(1912, 7,29)
      Time.parse("大正01年07月30日").should == Time.local(1912, 7,30)
      Time.parse("大正15年12月24日").should == Time.local(1926,12,24)
      Time.parse("昭和01年12月25日").should == Time.local(1926,12,25)
      Time.parse("昭和64年01月07日").should == Time.local(1989, 1, 7)
      Time.parse("平成01年01月08日").should == Time.local(1989, 1, 8)
      Time.parse("平成22年06月09日").should == Time.local(2010, 6, 9)
      Time.parse("平成62年12月31日").should == Time.local(2050,12,31)
      Time.parse("平成22年06月09日 12時34分56秒").should == Time.local(2010, 6, 9, 12, 34, 56)
    end

    it "with chinese charactor short era name (漢字省略表記の元号)" do
      Time.parse("明元年1月1日").should == Time.local(1868, 1, 1)
      Time.parse("明1年1月1日").should == Time.local(1868, 1, 1)
      Time.parse("明01年01月01日").should == Time.local(1868, 1, 1)
      Time.parse("明45年07月29日").should == Time.local(1912, 7,29)
      Time.parse("大01年07月30日").should == Time.local(1912, 7,30)
      Time.parse("大15年12月24日").should == Time.local(1926,12,24)
      Time.parse("昭01年12月25日").should == Time.local(1926,12,25)
      Time.parse("昭64年01月07日").should == Time.local(1989, 1, 7)
      Time.parse("平01年01月08日").should == Time.local(1989, 1, 8)
      Time.parse("平22年06月09日").should == Time.local(2010, 6, 9)
      Time.parse("平62年12月31日").should == Time.local(2050,12,31)
    end

  end

  describe :[] do
    describe "should return an Era object" do
      it "for era_name" do
        [:meiji, :taisho, :showa, :heisei].each do |era|
          Time.eras[era].class.should == Warekky::Era
          Time.eras[era.to_s].class.should == Warekky::Era
        end
        Time.eras[nil].should == nil
        Time.eras[''].should == nil
        Time.eras[:unexist_era].should == nil
      end

      it "for era_name with kanji" do
        %w[M T S H 明治 大正 昭和 平成 明 大 昭 平].each do |era|
          Time.eras[era].class.should == Warekky::Era
        end
      end

      it "for date" do
        Time.eras[Time.local(1867,12,31)].should == nil
        Time.eras[Time.local(1868, 1, 1)].name.should == 'meiji'
        Time.eras[Time.local(1912, 7,29)].name.should == 'meiji'
        Time.eras[Time.local(1912, 7,30)].name.should == 'taisho'
        Time.eras[Time.local(1926,12,24)].name.should == 'taisho'
        Time.eras[Time.local(1926,12,25)].name.should == 'showa'
        Time.eras[Time.local(1989, 1, 7)].name.should == 'showa'
        Time.eras[Time.local(1989, 1, 8)].name.should == 'heisei'
        Time.eras[Time.local(2010, 6, 9)].name.should == 'heisei'
        Time.eras[Time.local(2050,12,31)].name.should == 'heisei'
      end
    end
  end
end
