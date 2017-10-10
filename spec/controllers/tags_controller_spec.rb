require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  describe "POST #create" do
    before do
      user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
      cookies[:auth_token] = user.auth_token
    end

    describe "when perspective present" do
      context "when name is without space" do
        before do
          @tag = Tag.create(name: "test")
        end
        it "should add tag to stage" do
          stage = Stage.create(name: "test")
          stage.tags << @tag

          expect(stage.tags).to include(@tag)
        end

        it "should add tag to backdrop" do
          backdrop = Backdrop.create(name: "test")
          backdrop.tags << @tag

          expect(backdrop.tags).to include(@tag)
        end

        it "should add tag to sound" do
          sound = Sound.create(name: "test")
          sound.tags << @tag

          expect(sound.tags).to include(@tag)
        end

        it "should add tag to avatar" do
          avatar = Avatar.create(name: "test")
          avatar.tags << @tag

          expect(avatar.tags).to include(@tag)
        end
      end

      context "when name is with space" do
        before do
          @tag = Tag.create(name: "test space")
        end

        it "should format the tag name" do
          expect(@tag.name).to eq("test-space")
        end

        it "should add tag to stage" do
          stage = Stage.create(name: "test")
          stage.tags << @tag

          expect(stage.tags).to include(@tag)
        end

        it "should add tag to backdrop" do
          backdrop = Backdrop.create(name: "test")
          backdrop.tags << @tag

          expect(backdrop.tags).to include(@tag)
        end

        it "should add tag to sound" do
          sound = Sound.create(name: "test")
          sound.tags << @tag

          expect(sound.tags).to include(@tag)
        end

        it "should add tag to avatar" do
          avatar = Avatar.create(name: "test")
          avatar.tags << @tag

          expect(avatar.tags).to include(@tag)
        end
      end

      context "when the name is empty" do
        before do
          @tag = Tag.create(name: "")
        end

        it "flash danger when name is empty" do
          stage = Stage.create(name: "test")
          stage.tags << @tag

          expect(flash[:danger]).to be_present
        end
      end
    end
  end
end
