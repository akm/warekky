# -*- coding: utf-8 -*-
require File.expand_path('../spec_helper', File.dirname(__FILE__))

class ChineseTest < Warekky::EraGroup
  # see http://ja.wikipedia.org/wiki/元号一覧_(中国)
  # pronounciation found on 
  # http://www.mdbg.net/chindict/chindict.php?dss=1&wdrst=1&wdqchi=宣統

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
end
