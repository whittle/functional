require 'rspec/core'
require 'rspec/expectations'
require 'rr'
require 'faker'
require File.expand_path '../support', __FILE__

begin
  require 'ruby-debug'
  $debugger = true
rescue LoadError
  $debugger = false
end

$test_db = {
  :adapter => 'sqlite3',
  :database => ENV['TEST_DB'] || sandbox('test_db.sqlite3')
}

RSpec.configure do |config|
  config.mock_with :rr
  config.before(:all) { create_sandbox }
  config.around(:each) { |ex| Debugger.start &ex }  if $debugger
  config.after(:all) { clean_sandbox }
end

RSpec::Matchers.module_eval { alias_method :expects, :expect }
