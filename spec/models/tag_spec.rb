require 'rails_helper'

describe Tag do
  describe "Associaltions" do
    it { should have_many(:avatar_tags).dependent(:destroy) }
    it { should have_many(:avatars).through(:avatar_tags) }
    it { should have_many(:stage_tags).dependent(:destroy) }
    it { should have_many(:stages).through(:stage_tags) }
    it { should have_many(:sound_tags).dependent(:destroy) }
    it { should have_many(:sounds).through(:sound_tags) }
    it { should have_many(:backdrop_tags).dependent(:destroy) }
    it { should have_many(:backdrops).through(:backdrop_tags) }
  end

  describe "Validations" do
    it { should validate_presence_of :name }

    it "should validates uniqueness of name" do
      t = Tag.create(name: "Tag1")
      
      should validate_uniqueness_of(:name).case_insensitive
    end

    it "should have error message when tag name is empty" do
      t = Tag.create(name: "")

      expect(t.errors.messages).to include(name: ["can't be blank"])
    end

    context "name should not be over 25 character in length" do
      it "name length less than 25" do
        t = Tag.create(name: "tag name less than 25")

        expect(t).to be_valid
      end

      it "name length is 25" do
        t = Tag.create(name: "tag name is 25 character.")

        expect(t).to be_valid
      end

      it "name length over 25" do
        t = Tag.create(name: "tag name is over 25 characters")

        expect(t).to_not be_valid
      end
    end
  end

  describe "standardize_name" do
    context "when name is not empty and doesnt contain space" do
      it "should not change the name" do
        t = Tag.create(name: "test")

        expect(t.name).to eq("test")
      end
    end

    context "when name is not empty and contains space" do
      it "should change the space to -" do
        t = Tag.create(name: "test space")

        expect(t.name).to eq("test-space")
      end
    end
  end
end
