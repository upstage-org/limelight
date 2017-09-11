require 'rails_helper'

describe AvatarStage do
  describe "#Associations" do
    it { should belong_to :stage }
    it { should belong_to :avatar }
  end

  describe "#Validations" do
    it { should validate_presence_of :stage }
    it { should validate_presence_of :avatar }
  end
end
