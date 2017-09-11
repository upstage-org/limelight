require 'rails_helper'

describe UserRole do
  it { should_belong_to :stage }
  it { should_belong_to :sound }
end
