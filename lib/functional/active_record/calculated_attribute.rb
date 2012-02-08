# -*- coding: utf-8 -*-
if  defined? ActiveRecord
  require 'active_support/core_ext/module/delegation'

  module ActiveRecord
    module CalculatedAttribute
      extend ActiveSupport::Concern

      module ClassMethods
        # Link an attribute and a calculation in your model.  This
        # method is the entirety of the public interface to this module.
        #
        # Examples:
        #
        # calculated_attribute :reason do |email|
        #   if email.cause.respond_to? :reason
        #     email.cause.reason
        #   end
        # end
        #
        # calc_attr(:action_at) { 3.days.from_now }
        #
        def calculated_attribute(name, &block)
          calculator_factory.add_calculation name, &block
          define_accessor name  unless method_defined? name
          chain_calculation_method name
        end
        alias_method :calc_attr, :calculated_attribute

        # Each model class has its own CalculatorFactory instance, in
        # which it aggregates the attribute-calculation pairs.
        def calculator_factory(calculations = {})
          @calculator_factory ||= CalculatorFactory.new(calculations)
        end

        # Define an accessor for attributes, so they can be chained.
        def define_accessor(name)
          define_method(name) { read_attribute name }
        end

        # Chain the accessor the ActiveSupport way.
        def chain_calculation_method(name)
          define_method "#{name}_with_calculation" do
            calculate name, send("#{name}_without_calculation")
          end
          alias_method_chain name, :calculation
        end
      end

      class CalculatorFactory < Struct.new :calculations
        def add_calculation(name, &block)
          calculations[name] = block
        end

        # Note that this is an instance method, and so does not override
        # the class method ::new.
        def new(model_instance)
          Calculator.new model_instance, calculations
        end
      end

      module InstanceMethods
        # Each model instance has its own Calculator instance.
        def calculator
          @calculator ||= self.class.calculator_factory.new self
        end
        delegate :calculate, :to => :calculator
      end

      class Calculator < Struct.new :model, :calculations
        # The model may implement an #automatic? method to get
        # calculations. Otherwise, it is assumed that all defined
        # calculations should be run.
        def automatic?
          !model.respond_to?(:automatic?) || model.automatic?
        end

        # Don’t calculate over supplied values.
        def calculate?(value)
          automatic? && value.nil?
        end

        # The calculate method has the intentional side-effect of
        # assigning to the field, so that the calculation will be
        # persisted.
        def calculate(name, value)
          return value  unless calculate? value
          model.send "#{name}=", perform_calculation(calculations[name])
        end

        def perform_calculation(proc)
          proc.arity == 1 ? proc.call(model) : model.instance_eval(&proc)
        end
      end
    end
  end
end
