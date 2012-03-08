# Functional

This library is my repository of helpful methods and macros for
writing more functional code in Ruby and Rails.

[![Build Status](https://secure.travis-ci.org/whittle/functional.png?branch=master)](http://travis-ci.org/whittle/functional)
[![Dependency Status](https://gemnasium.com/whittle/functional.png)](https://gemnasium.com/whittle/functional)

## How not to require

The separate extensions are intended to be required piecemeal. As
such, **requiring the lib/functional file does nothing but print a
warning**. If you really, __really__ want everything, soup-to-nuts,
require functional/all.

## Contents

Ruby core library extentions:

- Array#repeating_take
- BigDecimal#positive?
- BigDecimal#negative?
- BigDecimal#unity_sign
- Kernel#let
- Object#unfold

Rails extentions:

- ActiveModel::CalculationPrerequisites
- ActiveRecord::CalculatedAttribute
