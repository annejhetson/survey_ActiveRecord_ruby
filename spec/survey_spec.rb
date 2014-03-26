require 'spec_helper'

describe Survey do
  it { should have_many(:questions) }
  it { should have_many(:answers).through(:questions) }
end
