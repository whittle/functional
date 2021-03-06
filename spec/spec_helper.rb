require 'rspec/core'
require 'rspec/expectations'
require 'rr'
require 'faker'

$spec_support_dir = File.expand_path '../support', __FILE__
require File.expand_path 'have_extension', $spec_support_dir

begin
  require 'ruby-debug'
  $debugger = true
rescue LoadError
  $debugger = false
end

$test_db = {
  :adapter => 'sqlite3',
  :database => ':memory:'
}

RSpec.configure do |config|
  config.mock_with :rr
  config.around(:each) { |ex| Debugger.start &ex }  if $debugger
end

RSpec::Matchers.module_eval { alias_method :expects, :expect }
