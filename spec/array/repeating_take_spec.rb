require 'functional/array/repeating_take'
require 'spec_helper'

describe Array do
  context 'for an empty array' do
    let(:array) { [] }

    describe '#repeating_take(0)' do
      subject { array.repeating_take 0 }
      it { should == [] }
    end

    describe '#repeating_take(1)' do
      it { expects { array.repeating_take 1 }.to raise_error }
    end
  end

  context 'for a one-element array' do
    let(:array) { [:a] }
    it { array.repeating_take(rand(10)).all? { |element| element == :a }.should be_true }
  end

  context 'for a three-element array' do
    let(:array) { [:a, :b, :c] }
    it { array.repeating_take(0).should == [] }
    it { array.repeating_take(1).should == [:a] }
    it { array.repeating_take(2).should == [:a, :b] }
    it { array.repeating_take(3).should == [:a, :b, :c] }
    it { array.repeating_take(4).should == [:a, :b, :c, :a] }
    it { array.repeating_take(5).should == [:a, :b, :c, :a, :b] }
    it { array.repeating_take(6).should == [:a, :b, :c, :a, :b, :c] }
    it { array.repeating_take(7).should == [:a, :b, :c, :a, :b, :c, :a] }
  end
end
