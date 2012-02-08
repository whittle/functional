class Array
  module RepeatingTake
    # Mimics the effect of taking from an infinitely repeating list.
    def repeating_take(number)
      return Array.new  if number < 1
      (self * ((number / size) + 1)).take number
    end
  end
end

::Array.class_eval { include Array::RepeatingTake }
