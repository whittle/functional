# Copied in part from
# rspec-rails-2.8.1:lib/rspec/rails/extensions/active_record/base.rb
if defined?(RSpec) && defined?(ActiveModel)
  module ::ActiveModel::Validations
    # Extension to enhance `should have` on AR Model instances.  Calls
    # model.valid? in order to prepare the object's errors object.
    def errors_on(attribute)
      valid?
      [errors[attribute]].flatten.compact
    end
    alias :error_on :errors_on
  end
end
