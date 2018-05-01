require 'rails_helper'

describe AvatarsController do

let(:avatars) { Avatar.all }
let(:avatars) { Avatar.new }

describe "GET #index" do
it "assigns all backdrops to @backdrops" do
get :index
expect(assigns(:avatars)).to eq(@avatars)
end

it "is a success" do
expect(response).to have_http_status(:ok)
end

it "render 'index' template" do
user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
cookies[:auth_token] = user.auth_token
get :index
expect(response).to render_template('index')
end
end

describe "GET #new" do
it "assigns backdrop to @avatar" do
get :new
expect(assigns(:avatar)).to eq(@avatar)
end

it "is a success" do
expect(response).to have_http_status(:ok)
end

it "render new avatar" do
expect(response).to render_template(@avatar)
end
end


describe "POST #create" do
before do
user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
cookies[:auth_token] = user.auth_token
end

context "when there is a valid avatar" do
subject { post :create, :params => { :avatar => { name: "Pass Type", source_name: "avat1", source_content_type: "image/png" } } }

it "redirects to edit backdrop path" do
expect(subject).to redirect_to(edit_avatar_path(Avatar.last))
end

it "sets flash[:success]" do
avatar = subject
expect(flash[:success]).to be_present
end
end

context "when there is an invalid avatar" do
subject { post :create, :params => { :avatar => { name: "" } } }

it "renders 'new' template" do
expect(subject).to render_template('new')
end

it "sets flash[:danger]" do
avatar = subject
expect(flash[:danger]).to be_present
end
end
end

describe "#show" do
subject { post :create, :params => { :avatar => { name: "Pass Type", source_name: "avat1", source_content_type: "image/png" } } }

it "redirect to edit avatar path" do
user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
cookies[:auth_token] = user.auth_token
expect(subject).to redirect_to(edit_avatar_path(Avatar.last))
end
end

describe "#PATCH update" do
before do
user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
cookies[:auth_token] = user.auth_token
end

context "when a stage is present" do
before do
request.env["HTTP_REFERER"] = "previous_page"
@avatar = Avatar.create(name: "avat1")
@stage = Stage.create(name: "testStage", owner_id: "1")
@stage.avatars << @avatar
patch :update, :params => { stage_slug: @stage.slug, stage: @stage, slug: @avatar.slug, avatar: { name: "New name" } }
@avatar.reload
end

it "add avatar to the stage" do
expect(@stage.avatars).to include(@avatar)
end

it "flash success message" do
expect(flash[:success]).to be_present
end

it "redirects back to the referring page" do
expect(response).to redirect_to "previous_page"
end
end

context "when a stage is not present" do
context "when @avatar.update(avatar_params) is true" do
before do
@avatar = Avatar.create(name: "avat1")
patch :update, :params => { slug: @avatar.slug, avatar: { name: "New name" } }
@avatar.reload
end

it "flash success message" do
expect(flash[:success]).to be_present
end

it "redirect to the edit avatar path" do
expect(response).to redirect_to(edit_avatar_path(@avatar))
end

it "change the name to the new name" do
expect(@avatar.name).to eq("New name")
end
end

context "when @avatar.update(avatar_params) is false" do
before do
@avatar = Avatar.create(name: "avat1")
patch :update, :params => { slug: @avatar.slug, avatar: { name: "" } }
@avatar.reload
end

it "flash danger message" do
expect(flash.now[:danger]).to be_present
end

it "render edit" do
expect(response).to render_template("edit")
end
end
end
end

describe "DELETE destroy" do
before do
user = User.create({ username: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
cookies[:auth_token] = user.auth_token
end

context "when a stage is present" do
before do
request.env["HTTP_REFERER"] = "previous_page"
@avatar = Avatar.create(name: "avat1")
@stage = Stage.create(name: "testStage", owner_id: "1")
@stage.avatars << @avatar
delete :destroy, :params => { stage_slug: @stage.slug, stage: @stage, slug: @avatar.slug, avatar: @avatar }
@stage.reload
end

it "delete avatar from the stage" do
expect(@stage.avatars).to_not include(@avatar)
end

it "flash success message" do
expect(flash[:success]).to be_present
end

it "redirects back to the referring page" do
expect(response).to redirect_to "previous_page"
end
end

context "when a stage not present" do
context "when @avatar.destroy is true" do
before do
@avatar = Avatar.create(name: "avat1")
delete :destroy, :params => { slug: @avatar.slug, avatar: @avatar }
end

it "destroy the avatar" do
expect(Avatar.all).to_not include(@avatar)
end

it "flash success message" do
expect(flash[:success]).to be_present
end

it "redirect to avatars path" do
expect(response).to redirect_to(media_path)
end
end

context "when @avatar.destroy is false" do
it "flash danger message" do
avatar = double
allow(Avatar).to receive(:find_by_slug!).and_return(avatar)
allow(avatar).to receive(:slug).and_return("abc")
allow(avatar).to receive(:destroy).and_return(false)

delete :destroy, :params => { slug: avatar.slug, avatar: avatar }

expect(flash[:danger]).to be_present
end

it "redirect to edit avatar path" do
avatar = double
allow(Avatar).to receive(:find_by_slug!).and_return(avatar)
allow(avatar).to receive(:slug).and_return("abc")
allow(avatar).to receive(:destroy).and_return(false)

delete :destroy, :params => { slug: avatar.slug, avatar: avatar }

expect(response).to redirect_to(edit_avatar_path(avatar))
end
end
end
end
end
