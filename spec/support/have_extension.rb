# Copied in part from
# rspec-rails-2.8.1:lib/rspec/rails/matchers/have_extension.rb
if  defined? RSpec && defined? ActiveSupport
  require 'active_support/core_ext/module/aliasing'

  module RSpec::Extensions
    module HaveExtensions
      extend ActiveSupport::Concern
      # Enhances the failure message for `should have(n)` matchers
      def failure_message_for_should_with_errors_on_extensions
        case @collection_name
        when :errors_on
          "expected #{relativities[@relativity]}#{@expected} errors on :#{@args[0]}, got #{@actual}"
        when :error_on
          "expected #{relativities[@relativity]}#{@expected} error on :#{@args[0]}, got #{@actual}"
        else
          failure_message_for_should_without_errors_on_extensions
        end
      end

      # Enhances the description for `should have(n)` matchers
      def description_with_errors_on_extensions
        case @collection_name
        when :errors_on
          "have #{relativities[@relativity]}#{@expected} errors on :#{@args[0]}"
        when :error_on
          "have #{relativities[@relativity]}#{@expected} error on :#{@args[0]}"
        else
          description_without_errors_on_extensions
        end
      end

      included do
        alias_method_chain :failure_message_for_should, :errors_on_extensions
        alias_method_chain :description, :errors_on_extensions
      end
    end
  end

  RSpec::Matchers::Have.class_eval { include RSpec::Extensions::HaveExtensions }
end
