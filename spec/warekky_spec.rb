# -*- coding: utf-8 -*-
require File.expand_path('./spec_helper', File.dirname(__FILE__))

describe Warekky::Era do

  before :all do
    Warekky.era_group = nil
  end

  describe :strftime do
    it "invoke original method" do
      d = Date.new(2010, 6, 10)
      Warekky.strftime(d, "%Y/%m/%d").should == "2010/06/10"
    end

    it "%n means newline" do
      d = Date.new(2010, 6, 10)
      begin
        Warekky.strftime(d, "%Y%n%m%n%d").should == "2010\n06\n10"
      rescue Exception => e
        puts e.backtrace.join("\n  ")
        raise
      end
    end
  end

  describe :parse do
    it "invoke original method" do
      Warekky.parse("2010/06/10 12:34:56").should == DateTime.new(2010, 6, 10, 12, 34, 56)
    end
  end

  describe :try_without do
    it "invoke original method" do
      Object.respond_to?(:class).should == true
      Object.respond_to?(:class_with_warekky).should == false
      Warekky.try_without(Object, :class).should == Class
    end
  end

end
