# Functional

This library is my repository of helpful methods and macros for
writing more functional code in Ruby and Rails.

## Warning

The separate extensions are intended to be required piecemeal. As
such, **requiring the lib/functional file does nothing but print a
warning**. If you really, __really__ want everything, soup-to-nuts,
require functional/all.

## Contents

Array#repeating_take
BigDecimal#positive?
BigDecimal#negative?
BigDecimal#unity_sign
Kernel#let
Object#unfold

ActiveModel::CalculationPrerequisites
ActiveRecord::CalculatedAttribute
