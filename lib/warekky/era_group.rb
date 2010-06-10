# -*- coding: utf-8 -*-
require 'warekky'

module Warekky
  class EraGroup
    def eras
      self.class.eras
    end
    def name_to_era
      self.class.name_to_era
    end

    def era_extra_names
      # インスタンスでは変更できないようにするので、引数を渡しません
      self.class.era_extra_names
    end


    def parse(str, options = {})
      raise NotImplementedError, "#{self.class.name}#parse has not been implemented."
    end

    def [](era_name_or_date_or_time)
      case era_name_or_date_or_time
      when Symbol, String then
        name_to_era[era_name_or_date_or_time]
      when Time, Date then
        eras.detect{|era| era.match?(era_name_or_date_or_time)}
      end
    end

    class << self
      def eras
        @eras ||= []
      end
      def name_to_era
        unless @name_to_era
          @name_to_era = eras.inject({}) do |d, era|
            d[era.key] = era
            d[era.key.to_s] = era
            d[era.sign] = era
            era_extra_names.each do |extra_name|
              d[era[extra_name]] = era
            end
            d
          end
        end
        @name_to_era
      end

      def era_extra_names(*args)
        @era_extra_names = args unless args.empty?
        @era_extra_names ||= []
      end

      def era(first, last, key, sign, options = {})
        key = key.to_sym
        result = Era.new(key, sign, first, last, options).freeze
        eras << result
        result
      end

      attr_accessor :regexp_builder
      def regexp(&block)
        @regexp_builder = block
      end
      
    end

  end
end
