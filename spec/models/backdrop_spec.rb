require 'rails_helper'

describe Backdrop do

  describe "Associations" do
    it { should have_many(:stage_backdrops).dependent(:destroy) }
    it { should have_many(:stages).through(:stage_backdrops) }
    it { should have_many(:backdrop_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:backdrop_tags) }
  end

  describe "Validations" do
    it { should have_attached_file(:source) }

    it { should validate_presence_of :name }
    it { should validate_attachment_content_type(:source).
                 allowing('image/png', 'image/gif','image/jpg', 'image/jpeg')}

    it "should valdate image file type" do
      b = Backdrop.create(name: "Pass Type", source_content_type: "image/png")
      expect(b).to be_valid
    end
    it "should not validate other content_type" do
      b = Backdrop.create(name: "Fail Type", source_content_type: "audio/mp3")
      expect(b).to_not be_valid
    end
  end

  describe ".not_assigned" do
    it "should return a list of backdrop that is not added to the stage" do
      b = Backdrop.create(name: "backdrop1")
      s = Stage.create(name: "RSpecTestStage", owner_id: "1")

      expect(Backdrop.not_assigned(s)).to include(b)
    end

    it "should not return a list of backdrop containing b" do
      b = [Backdrop.create(name: "backdrop1")]
      s2 = Stage.create(name: "RSpecTestStage", owner_id: "1", backdrops: b)

      expect(Backdrop.not_assigned(s2)).to_not include(b)
    end
  end
end
