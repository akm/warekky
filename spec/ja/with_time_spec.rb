# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe "Warekky" do

  before :all do
    Warekky.era_group_class = Warekky::Ja
  end

  describe :strftime do
    it "without era name (元号の指定なし)" do
      Warekky.strftime(Time.local(1867,12,31), '%Y.%m.%d').should == "1867.12.31"
      Warekky.strftime(Time.local(1868, 1, 1), '%Y.%m.%d').should == "1868.01.01"
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      fmt = '%g%N/%m/%d'
      Warekky.strftime(Time.local(1867,12,31), fmt).should == "1867/12/31"
      Warekky.strftime(Time.local(1868, 1, 1), fmt).should == "M01/01/01"
      Warekky.strftime(Time.local(1912, 7,29), fmt).should == "M45/07/29"
      Warekky.strftime(Time.local(1912, 7,30), fmt).should == "T01/07/30"
      Warekky.strftime(Time.local(1926,12,24), fmt).should == "T15/12/24"
      Warekky.strftime(Time.local(1926,12,25), fmt).should == "S01/12/25"
      Warekky.strftime(Time.local(1989, 1, 7), fmt).should == "S64/01/07"
      Warekky.strftime(Time.local(1989, 1, 8), fmt).should == "H01/01/08"
      Warekky.strftime(Time.local(2010, 6, 9), fmt).should == "H22/06/09"
      Warekky.strftime(Time.local(2050,12,31), fmt).should == "H62/12/31"
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      fmt = '%G%N/%m/%d'
      Warekky.strftime(Time.local(1867,12,31), fmt).should == "1867/12/31"
      Warekky.strftime(Time.local(1868, 1, 1), fmt).should == "明治01/01/01"
      Warekky.strftime(Time.local(1912, 7,29), fmt).should == "明治45/07/29"
      Warekky.strftime(Time.local(1912, 7,30), fmt).should == "大正01/07/30"
      Warekky.strftime(Time.local(1926,12,24), fmt).should == "大正15/12/24"
      Warekky.strftime(Time.local(1926,12,25), fmt).should == "昭和01/12/25"
      Warekky.strftime(Time.local(1989, 1, 7), fmt).should == "昭和64/01/07"
      Warekky.strftime(Time.local(1989, 1, 8), fmt).should == "平成01/01/08"
      Warekky.strftime(Time.local(2010, 6, 9), fmt).should == "平成22/06/09"
      Warekky.strftime(Time.local(2050,12,31), fmt).should == "平成62/12/31"
    end

    it "with chinese charactor era name (漢字表記の元号) %nの改行入り" do
      fmt = '%G%N年%n%m月%n%d日'
      Warekky.strftime(Time.local(1867,12,31), fmt).should == "1867年\n12月\n31日"
      Warekky.strftime(Time.local(1868, 1, 1), fmt).should == "明治01年\n01月\n01日"
      Warekky.strftime(Time.local(1912, 7,29), fmt).should == "明治45年\n07月\n29日"
      Warekky.strftime(Time.local(1912, 7,30), fmt).should == "大正01年\n07月\n30日"
      Warekky.strftime(Time.local(1926,12,24), fmt).should == "大正15年\n12月\n24日"
      Warekky.strftime(Time.local(1926,12,25), fmt).should == "昭和01年\n12月\n25日"
      Warekky.strftime(Time.local(1989, 1, 7), fmt).should == "昭和64年\n01月\n07日"
      Warekky.strftime(Time.local(1989, 1, 8), fmt).should == "平成01年\n01月\n08日"
      Warekky.strftime(Time.local(2010, 6, 9), fmt).should == "平成22年\n06月\n09日"
      Warekky.strftime(Time.local(2050,12,31), fmt).should == "平成62年\n12月\n31日"
    end
  end

  describe :parse do
    it "without era name (元号の指定なし)" do
      Warekky.parse("1867/12/31", :class => Time).should == Time.local(1867,12,31)
    end

    it "with alphabet era name (アルファベット表記の元号)" do
      Warekky.parse("M01/01/01", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("M45/07/29", :class => Time).should == Time.local(1912, 7,29)
      Warekky.parse("T01/07/30", :class => Time).should == Time.local(1912, 7,30)
      Warekky.parse("T15/12/24", :class => Time).should == Time.local(1926,12,24)
      Warekky.parse("S01/12/25", :class => Time).should == Time.local(1926,12,25)
      Warekky.parse("S64/01/07", :class => Time).should == Time.local(1989, 1, 7)
      Warekky.parse("H01/01/08", :class => Time).should == Time.local(1989, 1, 8)
      Warekky.parse("H22/06/09", :class => Time).should == Time.local(2010, 6, 9)
      Warekky.parse("H62/12/31", :class => Time).should == Time.local(2050,12,31)
      Warekky.parse("H22/06/09 01:23:45", :class => Time).should == Time.local(2010, 6, 9, 1, 23, 45)
    end

    context "区切りなし" do
      it "by Time.parse" do
        Time.parse("18671231").should == Time.local(1867, 12, 31)
        Time.parse("18671231 012345") == Time.local(1867, 12, 31, 1, 23, 45)
        Time.parse("18671231012345") == Time.local(1867, 12, 31, 1, 23, 45)
      end

      it "by Warekky.parse" do
        Warekky.parse("M010101", :class => Time).should == Time.local(1868, 1, 1)
        Warekky.parse("M450729", :class => Time).should == Time.local(1912, 7,29)
        Warekky.parse("T010730", :class => Time).should == Time.local(1912, 7,30)
        Warekky.parse("T151224", :class => Time).should == Time.local(1926,12,24)
        Warekky.parse("S011225", :class => Time).should == Time.local(1926,12,25)
        Warekky.parse("S640107", :class => Time).should == Time.local(1989, 1, 7)
        Warekky.parse("H010108", :class => Time).should == Time.local(1989, 1, 8)
        Warekky.parse("H220609", :class => Time).should == Time.local(2010, 6, 9)
        Warekky.parse("H621231", :class => Time).should == Time.local(2050,12,31)
        Warekky.parse("H220609 012345", :class => Time).should == Time.local(2010, 6, 9, 1, 23, 45)
        Warekky.parse("H220609012345", :class => Time).should == Time.local(2010, 6, 9, 1, 23, 45)
      end
    end

    it "with chinese charactor era name (漢字表記の元号)" do
      Warekky.parse("明治元年1月1日", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("明治1年1月1日", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("明治01年01月01日", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("明治45年07月29日", :class => Time).should == Time.local(1912, 7,29)
      Warekky.parse("大正01年07月30日", :class => Time).should == Time.local(1912, 7,30)
      Warekky.parse("大正15年12月24日", :class => Time).should == Time.local(1926,12,24)
      Warekky.parse("昭和01年12月25日", :class => Time).should == Time.local(1926,12,25)
      Warekky.parse("昭和64年01月07日", :class => Time).should == Time.local(1989, 1, 7)
      Warekky.parse("平成01年01月08日", :class => Time).should == Time.local(1989, 1, 8)
      Warekky.parse("平成22年06月09日", :class => Time).should == Time.local(2010, 6, 9)
      Warekky.parse("平成62年12月31日", :class => Time).should == Time.local(2050,12,31)
      Warekky.parse("平成22年06月09日 12時34分56秒", :class => Time).should == Time.local(2010, 6, 9, 12, 34, 56)
    end

    it "with chinese charactor short era name (漢字省略表記の元号)" do
      Warekky.parse("明元年1月1日", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("明1年1月1日", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("明01年01月01日", :class => Time).should == Time.local(1868, 1, 1)
      Warekky.parse("明45年07月29日", :class => Time).should == Time.local(1912, 7,29)
      Warekky.parse("大01年07月30日", :class => Time).should == Time.local(1912, 7,30)
      Warekky.parse("大15年12月24日", :class => Time).should == Time.local(1926,12,24)
      Warekky.parse("昭01年12月25日", :class => Time).should == Time.local(1926,12,25)
      Warekky.parse("昭64年01月07日", :class => Time).should == Time.local(1989, 1, 7)
      Warekky.parse("平01年01月08日", :class => Time).should == Time.local(1989, 1, 8)
      Warekky.parse("平22年06月09日", :class => Time).should == Time.local(2010, 6, 9)
      Warekky.parse("平62年12月31日", :class => Time).should == Time.local(2050,12,31)
    end


  end

  describe :[] do
    describe "should return an Era object" do
      it "for date" do
        Warekky[Time.local(1867,12,31)].should == nil
        Warekky[Time.local(1868, 1, 1)].name.should == 'meiji'
        Warekky[Time.local(1912, 7,29)].name.should == 'meiji'
        Warekky[Time.local(1912, 7,30)].name.should == 'taisho'
        Warekky[Time.local(1926,12,24)].name.should == 'taisho'
        Warekky[Time.local(1926,12,25)].name.should == 'showa'
        Warekky[Time.local(1989, 1, 7)].name.should == 'showa'
        Warekky[Time.local(1989, 1, 8)].name.should == 'heisei'
        Warekky[Time.local(2010, 6, 9)].name.should == 'heisei'
        Warekky[Time.local(2050,12,31)].name.should == 'heisei'
      end
    end
  end
end
