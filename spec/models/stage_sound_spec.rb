require 'rails_helper'

describe StageSound do
  describe '#Associations' do
    it { should belong_to :stage }
    it { should belong_to :sound }
  end

  describe '#Validations' do
    it { should validate_presence_of :stage }
    it { should validate_presence_of :sound }
  end
end
