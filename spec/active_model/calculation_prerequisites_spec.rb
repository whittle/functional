require 'active_model'
require 'functional/active_model/calculation_prerequisites'
require 'spec_helper'
require File.expand_path 'active_model', $spec_support_dir

# FooBar is an example class intended to demonstrate both the public
# interface and inner workings of
# ActiveModel::CalculationPrerequisites. Silly names are used to avoid
# the cognitive overhead of thinking about a useful class at the same
# time. A more driven example can be found in the
# ActiveModel::CalculationPrerequisites module itself.
class FooBar < Struct.new :foo, :bar, :baz, :qux
  include ActiveModel::Validations
  include ActiveModel::CalculationPrerequisites
  validates_presence_of :qux # Unrelated to calculation
  final_calculation_prerequisite :foo
  validates_numericality_of :bar, :greater_than => 10
  final_calc_prereq :bar
  final_calculation :baz
end

module ActiveModel
  describe CalculationPrerequisites do
    subject { ::FooBar.new }
    before { subject.qux = 0 }

    context 'without a foo' do
      before { subject.foo = nil }
      it { should have(1).error_on :foo }
      it { should_not have(:any).errors_on :baz }
      it { should_not have_all_final_calculation_prerequisites }
    end

    context 'with a foo of 5' do
      before { subject.foo = 5 }
      it { should_not have(:any).errors_on :foo }

      context 'without a bar' do
        before { subject.bar = nil }
        it { should have(1).error_on :bar }
        it { should_not have(:any).errors_on :baz }
        it { should_not have_all_final_calculation_prerequisites }
      end

      context 'with a bar of 8' do
        before { subject.bar = 8 }
        it { should have(1).error_on :bar }
        it { should_not have(:any).errors_on :baz }
        it { should_not have_all_final_calculation_prerequisites }
      end

      context 'with a bar of 13' do
        before { subject.bar = 13 }
        it { should_not have(:any).errors_on :bar }
        it { should have_all_final_calculation_prerequisites }

        context 'without a baz' do
          before { subject.baz = nil }
          it { should have(1).error_on :baz }
        end

        context 'with a baz of 65' do
          before { subject.baz = 65 }
          it { should_not have(:any).errors_on :baz }
          it { should be_valid }
        end
      end
    end

    context 'without a qux' do
      before { subject.qux = nil }
      it { should have(1).error_on :qux }
    end
  end
end
