# -*- coding: utf-8 -*-
if  defined? ActiveModel
  module ActiveModel
    module CalculationPrerequisites
      extend ActiveSupport::Concern

      # CalculationPrerequisites provides a pair of related macros:
      #   1. `final_calculation_prerequisite`
      #   2. `final_calculation`
      #
      # These macros allow the identification of a final calculation and
      # the prerequisites that it depends on. This module is frequently
      # used in conjunction with ActiveRecord::CalculatedAttribute.
      #
      # A macro, in this context, is a class method that expands into a
      # significant amount of instance-oriented code.
      #
      # Example:
      #
      # # In our example class, each instance needs a debt and an
      # # employment in order to calculate a ratio.
      #
      # class DebtToIncome
      #   has_one :employment
      #   final_calculation_prerequisite :employment             # 1.
      #
      #   validates_numericality_of :debt, :greater_than => 0
      #   final_calculation_prerequisite :debt                   # 2.
      #
      #   calc_attr(:ratio) { debt / employment.income }         # 3.
      #   final_calculation :ratio                               # 4.
      # end
      #
      # In this example, any instance of the DebtToIncome needs a debt
      # and an employment in order to calculate the ratio.
      #
      # 1. This `final_calculation_prerequisite` macro call on
      #    :employment makes sure that instances of DebtToIncome always
      #    validated the presence of an employment.
      # 2. Because a validation has already been declared for debt, no
      #    additional validation is added by the subsequent macro call.
      #    Like all ActiveModel validations, it’s order-sensitive.
      # 3. Here, the macro from ActiveRecord::CalculatedAttribute is
      #    used to declare that the ratio attribute will be lazily
      #    evaluated. See that module for more information.
      # 4. Lastly, the `final_calculation` macro is used to identify
      #    `ratio` as the final attribute to be validated. This
      #    attribute will be called (and lazily calculated if declared
      #    using `calculated_attribute`) only once all the prerequisites
      #    have been validated. This saves us from exceptions on
      #    upstream attributes that don’t validate.

      module ClassMethods
        # Used to identify the final calculation that an instance will
        # perform. The presence of this calculation will be validated if
        # all of the prerequisites have been supplied to the instance.
        def final_calculation(name)
          validates_presence_of(name,
                                :if => :has_all_final_calculation_prerequisites?)
        end

        # Used to identify the prerequisites to the final
        # calculation. The presence of each will always be validated.
        def final_calculation_prerequisite(name)
          final_calculation_prerequisites << name
          validates_presence_of_final_calculation_prerequisite name
        end
        alias_method(:final_calc_prereq,
                     :final_calculation_prerequisite)

        # Add a presence validator only if no validators already exist
        # for the prereq.
        def validates_presence_of_final_calculation_prerequisite(name)
          return  unless validators_on(name).empty?
          validates_presence_of name
        end

        def final_calculation_validators
          final_calculation_prerequisites.map(&method(:validators_on)).flatten
        end
      end

      # Each class that includes this module should have its own prereq
      # list.
      included do
        class_attribute :final_calculation_prerequisites
        self.final_calculation_prerequisites = []
      end

      module InstanceMethods
        # Each instance can check if all of the prereqs have been met.
        def has_all_final_calculation_prerequisites?
          with_substitute_errors do
            self.class.final_calculation_validators.each do |validator|
              validator.validate self
            end
            return errors.empty?
          end
        end

        private

        # This is an ugly hack, but ActiveModel 3.0.4 assumes that
        # validations accept a record, that validations don’t output
        # their result but rather perform operations on an error hash,
        # and that the error hash is at record.errors. All we can really
        # do without patching ActiveModel is isolate the hack from the
        # rest of the code.
        def with_substitute_errors
          old_errors = errors.dup
          @errors = ActiveModel::Errors.new self
          yield
        ensure
          @errors = old_errors
        end
      end
    end
  end
end
