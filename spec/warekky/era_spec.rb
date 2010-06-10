# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe Warekky::Era do

  before :all do
    Warekky.era_group_class = nil
  end

  describe :[] do
    it "access to options" do
      era = Warekky::Era.new(:meiji , 'M', 
        '1868/01/01', '1912/07/29', :long => '明治', :short => "明")
      era[:long].should == "明治"
      era[:short].should == "明"
      era['long'].should == nil
      era['short'].should == nil
      era[:unexist].should == nil
      era[''].should == nil
      era[nil].should == nil
    end
  end

  describe :match? do
    it "both first and last" do
      era = Warekky::Era.new(:both, "B", "1993/04/01", "1998/03/31")
      { 
        "1993/03/31" => false,
        "1993/04/01" => true,
        "1998/03/31" => true,
        "1998/04/01" => false,
      }.each do |str, expected|
        era.match?(Date.parse(str)).should == expected
        era.match?(str).should == expected
      end
    end

    it "only first" do
      era = Warekky::Era.new(:fitst, "F", "1993/04/01", nil)
      { 
        "1993/03/31" => false,
        "1993/04/01" => true,
        "1998/03/31" => true,
        "1998/04/01" => true,
      }.each do |str, expected|
        era.match?(Date.parse(str)).should == expected
        era.match?(str).should == expected
      end
    end

    it "only last" do
      era = Warekky::Era.new(:last, "L", nil, "1998/03/31")
      { 
        "1993/03/31" => true,
        "1993/04/01" => true,
        "1998/03/31" => true,
        "1998/04/01" => false,
      }.each do |str, expected|
        era.match?(Date.parse(str)).should == expected
        era.match?(str).should == expected
      end
    end
  end

  describe :to_ad_year do
    it "should return ad year" do
      era = Warekky::Era.new(:meiji , 'M', '1868/01/01', '1912/07/29')
      era.to_ad_year(1).should == 1868
      era.to_ad_year("1").should == 1868
      era.to_ad_year(2).should == 1869
      era.to_ad_year(45).should == 1912
    end

    it "should return ad year for out of range" do
      era = Warekky::Era.new(:meiji , 'M', '1868/01/01', '1912/07/29')
      era.to_ad_year(-1).should == 1866
      era.to_ad_year(0).should == 1867
      era.to_ad_year(46).should == 1913
      era.to_ad_year(50).should == 1917
    end
  end

  describe :to_era_year do
    it "should return an era year" do
      era = Warekky::Era.new(:meiji , 'M', '1868/01/01', '1912/07/29')
      era.to_era_year(1868).should == 1
      era.to_era_year("1868").should == 1
      era.to_era_year(1869).should == 2
      era.to_era_year(1912).should == 45
    end

    it "should return ad year for out of range" do
      era = Warekky::Era.new(:meiji , 'M', '1868/01/01', '1912/07/29')
      era.to_era_year(1866).should == -1
      era.to_era_year(1867).should == 0
      era.to_era_year(1913).should == 46
      era.to_era_year(1917).should == 50
    end
  end
end
