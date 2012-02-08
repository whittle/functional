require 'spec_helper'

describe :functional do
  it { expects { require 'functional' }.to raise_error NotImplementedError }
end
