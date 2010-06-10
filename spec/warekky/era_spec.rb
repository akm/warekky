# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe Warekky::Era do

  before :all do
    Warekky.era_group_class = nil
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
end
