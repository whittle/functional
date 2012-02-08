require 'spec_helper'

describe :functional do
  it { expects { require 'functional/all' }.not_to raise_error }
end
