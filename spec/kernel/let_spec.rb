require 'functional/kernel/let'
require 'spec_helper'

describe Kernel do
  subject { let(3) { |i| i + 5 } }
  it { should == 8 }
end
