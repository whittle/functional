# -*- coding: utf-8 -*-
if defined? BigDecimal
  class BigDecimal
    module SignMethods
      # A predicate for positive values.
      def positive?
        self > 0
      end

      # A predicate for negative values.
      def negative?
        self < 0
      end

      # Sometimes there’s a need for a sign method that never has an
      # absolute value greater than one.
      def unity_sign
        (zero? || nan?) ? 0 : (sign / sign.abs)
      end
    end
  end

  BigDecimal.class_eval { include BigDecimal::SignMethods }
end
