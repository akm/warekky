require 'date'

module Warekky
  autoload :Era, 'warekky/era'
  autoload :EraGroup, 'warekky/era_group'
  autoload :Ja, 'warekky/ja'

  class << self
    attr_accessor :era_group_class
    attr_reader :era_group

    # d: Date or Time
    def strftime(d, format)
    end

    def parse(str, options = {})
      era_group ? era_group.parse(str, options) : DateTime.parse(str)
    end

    def era_group
      @era_group ||= era_group_class.new
    end

    def [](era_name_or_date_or_time)
      era_group[era_name_or_date_or_time]
    end

  end

end
