require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  describe "GET #create" do
    before do
      user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
      cookies[:auth_token] = user.auth_token
    end

    describe "when perspective present" do
      it "should add tag to stage" do
        stage = Stage.create(name: "test")
        tag = Tag.create(name: "testing")
        stage.tags << tag

        expect(stage.tags).to include(tag)
      end

      it "should add tag to stage" do
        stage = Stage.create(name: "test")
        tag = Tag.create(name: "testing")
        stage.tags << tag

        expect(stage.tags).to include(tag)
      end

      it "should add tag to backdrop" do
        backdrop = Backdrop.create(name: "test")
        tag = Tag.create(name: "testing")
        backdrop.tags << tag

        expect(backdrop.tags).to include(tag)
      end

      it "should add tag to sound" do
        sound = Sound.create(name: "test")
        tag = Tag.create(name: "testing")
        sound.tags << tag

        expect(sound.tags).to include(tag)
      end

      it "should add tag to avatar" do
        avatar = Avatar.create(name: "test")
        tag = Tag.create(name: "testing")
        avatar.tags << tag

        expect(avatar.tags).to include(tag)
      end
    end
  end

end
