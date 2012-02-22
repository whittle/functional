$spec_support_dir = File.expand_path '../support', __FILE__
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
