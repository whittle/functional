require 'rspec/core'
require 'rspec/expectations'
require 'rr'

begin
  require 'ruby-debug'
  $debugger = true
rescue LoadError
  $debugger = false
end

RSpec.configure do |config|
  config.mock_with :rr
  config.around(:each) { |ex| Debugger.start &ex }  if $debugger
end

RSpec::Matchers.module_eval { alias_method :expects, :expect }
