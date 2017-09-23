require 'rails_helper'

describe StageBackdrop do
  describe "#Associations" do
    it { should belong_to :stage }
    it { should belong_to :backdrop }
  end

  describe "#Validations" do
    it { should validate_presence_of :stage }
    it { should validate_presence_of :backdrop }
  end
end
