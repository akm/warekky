require 'warekky'

module Warekky
  class EraGroup
    def name_to_era
      self.class.name_to_era
    end
    def eras
      self.class.eras
    end

    def [](era_name_or_date_or_time)
      case era_name_or_date_or_time
      when Symbol, String then
        name_to_era[era_name_or_date_or_time.to_sym]
      when Time, Date then
        eras.detect{|era| era.match?(era_name_or_date_or_time)}
      end
    end

    class << self
      def eras
        @eras ||= []
      end
      def name_to_era
        @name_to_era ||= {}
      end

      def era(first, last, key, sign, options = {})
        key = key.to_sym
        result = Era.new(key, sign, first, last, options).freeze
        eras << result
        name_to_era[key] = result
        result
      end

      
    end

  end
end
