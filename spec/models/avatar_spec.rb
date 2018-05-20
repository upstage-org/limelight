require 'rails_helper'

describe Avatar do

  describe "Associations" do
    it { should have_many(:avatar_stages).dependent(:destroy) }
    it { should have_many(:stages).through(:avatar_stages) }
    it { should have_many(:avatar_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:avatar_tags) }
  end

  describe "Validations" do
    it { should have_attached_file(:source) }

    it { should validate_presence_of :name }
    it { should validate_attachment_content_type(:source).
                 allowing('image/png', 'image/gif','image/jpg', 'image/jpeg')}

    it "should valdate image file type" do
      user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
      a = Avatar.create(name: "Pass Type", source_content_type: "image/png")
      expect(a).to be_valid
    end
    it "should not validate other content_type" do
      a = Avatar.create(name: "Fail Type", source_content_type: "audio/mp3")
      expect(a).to_not be_valid
    end
  end

  describe ".not_assigned" do
    it "should return a list of avatars that are not added to the stage" do
      user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
      a = Avatar.create(name: "avatar1")
      s = Stage.create(name: "RSpecTestStage", owner_id: "1")

      expect(Avatar.not_assigned(s)).to include(a)
    end

    it "should not return a list of avatars containing b" do
      a = [Avatar.create(name: "avatar1")]
      s2 = Stage.create(name: "RSpecTestStage", owner_id: "1", avatars: a)

      expect(Avatar.not_assigned(s2)).to_not include(a)
    end
  end

end
