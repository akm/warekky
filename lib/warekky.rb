require 'date'

module Warekky
  autoload :Era, 'warekky/era'
  autoload :EraGroup, 'warekky/era_group'
  autoload :Ja, 'warekky/ja'

  class << self
    attr_accessor :era_group_class

    # d: Date or Time
    def strftime(d, format)
    end

    def parse(str)
    end

    def [](era_name_or_date_or_time)
    end

  end

end
