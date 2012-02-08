def sandbox(file = nil)
  File.expand_path "../../sandbox/#{file}", __FILE__
end

def create_sandbox
  Dir.mkdir sandbox  unless File.exists? sandbox
end

def clean_sandbox
  Dir.glob(sandbox('*')).each &File.method(:unlink)
  Dir.unlink sandbox
end
