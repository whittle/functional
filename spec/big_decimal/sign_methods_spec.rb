require 'bigdecimal'
require 'functional/big_decimal/sign_methods'
require 'spec_helper'

describe BigDecimal::SignMethods do
  context 'when greater than zero' do
    subject { BigDecimal.new Faker::Base.numerify('##1.##') }
    it { should be_positive }
    it { should_not be_negative }
    its(:unity_sign) { should == 1 }
  end

  context 'when less than zero' do
    subject { BigDecimal.new Faker::Base.numerify('-##9.##') }
    it { should_not be_positive }
    it { should be_negative }
    its(:unity_sign) { should == -1 }
  end

  context 'when exactly zero' do
    subject { BigDecimal.new '0' }
    it { should_not be_positive }
    it { should_not be_negative }
    its(:unity_sign) { should == 0 }
  end
end
