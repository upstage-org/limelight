require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  describe "POST #create" do
    before do
      user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
      cookies[:auth_token] = user.auth_token
    end

    describe "when perspective is present" do
      context "when name is without space" do
        it "should redirect to stage" do
          @controller = StagesController.new

          post :create, :params => { :stage => { :name => "sTest", :tag => {name: "test"} } }

          expect(response).to redirect_to(Stage.last)
        end

        it "should redirect to backdrop" do
          @controller = BackdropsController.new

          post :create, :params => { :backdrop => { :name => "bdTest", :tag => {name: "test"} } }

          expect(response).to redirect_to(edit_backdrop_path(Backdrop.last))
        end

        it "should redirect to sound" do
          @controller = SoundsController.new

          post :create, :params => { :sound => { :name => "soundTest", :tag => {name: "test"} } }

          expect(response).to redirect_to(edit_sound_path(Sound.last))
        end

        it "should add tag to avatar" do
          @controller = AvatarsController.new

          post :create, :params => { :avatar => { :name => "avatarTest", :tag => {name: "test"} } }

          expect(response).to redirect_to(edit_avatar_path(Avatar.last))
        end
      end

      context "when name is with space" do
        it "should redirects to stage" do
          @controller = StagesController.new

          post :create, :params => { :stage => { :name => "stageTest", :tag => {name: "test space"} } }

          expect(response).to redirect_to(Stage.last)
        end

        it "should redirects to backdrop" do
          @controller = BackdropsController.new

          post :create, :params => { :backdrop => { :name => "bdTest", :tag => {name: "test space"} } }

          expect(response).to redirect_to(edit_backdrop_path(Backdrop.last))
        end

        it "should redirects to sound" do
          @controller = SoundsController.new

          post :create, :params => { :sound => { :name => "soundTest", :tag => {name: "test space"} } }

          expect(response).to redirect_to(edit_sound_path(Sound.last))
        end

        it "should redirects to avatar" do
          @controller = AvatarsController.new

          post :create, :params => { :avatar => { :name => "avatarTest", :tag => {name: "test space"} } }

          expect(response).to redirect_to(edit_avatar_path(Avatar.last))
        end
      end

      context "when the tag already exist with space" do
        it "stage should only have one tag" do
          @controller = StagesController.new

          post :create, :params => { :stage => { :name => "stageTest", :tag => {name: "test space"} } }

          expect{
            post :create, :params => { :stage => { :name => "stageTest", :tag => {name: "test space"} } }
          }.to change{Tag.count}.by(0)
        end

        it "backdrop should only have one tag" do
          @controller = BackdropsController.new

          post :create, :params => { :backdrop => { :name => "bdTest", :tag => {name: "test space"} } }

          expect{
            post :create, :params => { :backdrop => { :name => "bdTest", :tag => {name: "test space"} } }
          }.to change{Tag.count}.by(0)
        end

        it "sound should only have one tag" do
          @controller = SoundsController.new

          post :create, :params => { :sound => { :name => "soundTest", :tag => {name: "test space"} } }

          expect{
            post :create, :params => { :sound => { :name => "soundTest", :tag => {name: "test space"} } }
          }.to change{Tag.count}.by(0)
        end

        it "avatar should only have one tag" do
          @controller = AvatarsController.new

          post :create, :params => { :avatar => { :name => "avatarTest", :tag => {name: "test space"} } }

          expect{
            post :create, :params => { :avatar => { :name => "avatarTest", :tag => {name: "test space"} } }
          }.to change{Tag.count}.by(0)
        end
      end

      context "when the tag already exist without space" do
        it "stage should only have one tag" do
          @controller = StagesController.new

          post :create, :params => { :stage => { :name => "stageTest", :tag => {name: "test"} } }

          expect{
            post :create, :params => { :stage => { :name => "stageTest", :tag => {name: "test"} } }
          }.to change{Tag.count}.by(0)
        end

        it "backdrop should only have one tag" do
          @controller = BackdropsController.new

          post :create, :params => { :backdrop => { :name => "bdTest", :tag => {name: "test"} } }

          expect{
            post :create, :params => { :backdrop => { :name => "bdTest", :tag => {name: "test"} } }
          }.to change{Tag.count}.by(0)
        end

        it "sound should only have one tag" do
          @controller = SoundsController.new

          post :create, :params => { :sound => { :name => "soundTest", :tag => {name: "test"} } }

          expect{
            post :create, :params => { :sound => { :name => "soundTest", :tag => {name: "test"} } }
          }.to change{Tag.count}.by(0)
        end

        it "avatar should only have one tag" do
          @controller = AvatarsController.new

          post :create, :params => { :avatar => { :name => "avatarTest", :tag => {name: "test"} } }

          expect{
            post :create, :params => { :avatar => { :name => "avatarTest", :tag => {name: "test"} } }
          }.to change{Tag.count}.by(0)
        end
      end
    end
  end
end
