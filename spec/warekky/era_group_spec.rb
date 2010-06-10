# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

class ChineseTest < Warekky::EraGroup
  # see http://ja.wikipedia.org/wiki/元号一覧_(中国)
  # pronounciation found on 
  # http://www.mdbg.net/chindict/chindict.php?dss=1&wdrst=1&wdqchi=宣統

  regexp do |era|
    [ /(?:#{Regexp.escape(era.name)})(?:\d{1,2})/,
      /(?:#{Regexp.escape(era.sign)})(?:\d{1,2})/]
  end

  era('1862/01/01', '1974/12/31', :tongzhi , '同治')
  era('1875/01/01', '1908/12/31', :guangxu , '光緒')
  era('1909/01/01', '1912/02/12', :xuantong, '宣統')
end

class VietnameseTest < Warekky::EraGroup
  era('1889/01/01', '1906/12/31', :thanh_thai, '成泰')
  era('1907/01/01', '1915/12/31', :duy_tan   , '維新')
  era('1916/01/01', '1925/12/31', :khai_djnh , '啓定')
  era('1926/01/01', '1945/12/31', :bao_dai   , '保大')
end


describe Warekky::EraGroup do

  before :all do
    Warekky.era_group_class = nil
  end

  describe :era do
    it "ChineseTest has 3 eras" do
      ChineseTest.eras.length.should == 3
    end

    it "VietnameseTest has 4 eras" do
      VietnameseTest.eras.length.should == 4
    end
  end

  describe :era_replacements do
    it "should match for names" do
      regexp1 = ChineseTest.era_replacements
      regexp1.match("同治").should be_false
      regexp1.match("光緒").should be_false
      regexp1.match("宣統").should be_false
      regexp1.match("1").should be_false
      regexp1.match("10").should be_false
      regexp1.match("同治1").should be_true
      regexp1.match("同治13").should be_true
      regexp1.match("光緒1").should be_true
      regexp1.match("光緒34").should be_true
      regexp1.match("宣統1").should be_true
      regexp1.match("宣統3").should be_true
    end
  end

end
