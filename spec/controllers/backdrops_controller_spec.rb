require 'rails_helper'

describe BackdropsController do

	let(:backdrops) { Backdrop.all }
	let(:backdrop) { Backdrop.new }
	let(:test) { Backdrop.create(name: "test1", source: "test1") }
	let(:teststage) { Stage.new }

	describe "GET #index" do

		it "assigns all backdrops to @backdrops" do
			get :index
			expect(assigns(:backdrops)).to eq(@backdrops)
		end

		it "is a success" do
			expect(response).to have_http_status(:ok)
		end

		it "render 'index' template" do
			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token
			get :index
			expect(response).to render_template('index')
		end
	end

	describe "GET #new" do
		it "assign bacdrop to @backdrop" do
			get :new
			expect(assigns(:backdrop)).to eq(@backdrop)
		end

		it "is a success" do
			expect(response).to have_http_status(:ok)
		end

		it "render new backdrop" do
			expect(response).to render_template(@backdrop)
		end
	end


	describe "POST #create" do
		context "Valid backdrop" do

			before :each do
				user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
				cookies[:auth_token] = user.auth_token				
			end

			subject { post :create, :params => { :backdrop => { name: "Pass Type", source_name: "bg1", source_content_type: "image/png" } } }

			it "should redirect to edit backdrop path" do
				expect(subject).to redirect_to(edit_backdrop_path(Backdrop.last))
	 		end

	 		it "should set flash[:success]" do
	 			backdrop = subject
	 			expect(flash[:success]).to be_present
	 		end
	 	end

	 	context "Invalid backdrop" do

	 		before :each do
	 			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			 	cookies[:auth_token] = user.auth_token
			 	post :create, :params => { :backdrop => { name: "" } }
	 		end

	 	 	it "should render 'new' template" do
	 	 		expect(response).to render_template('new')
	 	 	end

	 	 	it "should set flash[:danger]" do
	 	 		expect(flash[:danger]).to be_present
	 	 	end
	 	 end
	 end

	describe "#show" do

		subject { post :create, :params => { :backdrop => { name: "Pass Type", source_name: "bg1", source_content_type: "image/png" } } }

	 	it "should redirect to edit backdrop path" do
	 		user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token
			expect(subject).to redirect_to(edit_backdrop_path(Backdrop.last))
	 	end
	end

	describe "#PATCH update" do
		context "stage is present" do

			before :each do
				user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
				cookies[:auth_token] = user.auth_token
				@backdrop = Backdrop.create(name: "bg1")
				@stage = Stage.create(name: "testStage", owner_id: "1")
				@stage.backdrops << @backdrop
				patch :update, :params => { stage_slug: @stage.slug, stage: @stage, slug: @backdrop.slug, backdrop: { name: "New name" } }
				@backdrop.reload
			end

			it "should add backdrop to the stage" do				
				expect(@stage.backdrops).to include(@backdrop)
			end

			it "should flash success message" do
				expect(flash[:success]).to be_present
			end

			it "should redirect to the stage" do
				expect(response).to redirect_to(@stage)
			end
		end

		context "stage not present" do
			context "@backdrop.update(backdrop_params)" do
				before :each do
					@backdrop = Backdrop.create(name: "bg1")
					user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
					cookies[:auth_token] = user.auth_token	
					patch :update, :params => { slug: @backdrop.slug, backdrop: { name: "New name" } }
					@backdrop.reload
				end

				it "should flash success message" do
					expect(flash[:success]).to be_present
				end

				it "should redirect to the edit backdrop path" do
					expect(response).to redirect_to(edit_backdrop_path(@backdrop))
				end

				it "should change the name to the new name" do
					expect(@backdrop.name).to eq("New name")
				end
			end

			context "@backdrop.update(backdrop_params) eq false" do
				before :each do
					@backdrop = Backdrop.create(name: "bg1")
					user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
					cookies[:auth_token] = user.auth_token	
					patch :update, :params => { slug: @backdrop.slug, backdrop: { name: "" } }
					@backdrop.reload
				end

				it "should flash danger message" do
					expect(flash.now[:danger]).to be_present
				end

				it "should render edit" do
					expect(response).to render_template("edit")
				end
			end
		end
	end

	describe "DELETE destroy" do
		context "stage is present" do
			before :each do
				user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
				cookies[:auth_token] = user.auth_token
				@backdrop = Backdrop.create(name: "bg1")
				@stage = Stage.create(name: "testStage", owner_id: "1")
				@stage.backdrops << @backdrop
				delete :destroy, :params => { stage_slug: @stage.slug, stage: @stage, slug: @backdrop.slug, backdrop: @backdrop }
				@stage.reload
			end

			it "should delete backdrop from the stage" do
				expect(@stage.backdrops).to_not include(@backdrop)
			end

			it "should flash success message" do
				expect(flash[:success]).to be_present
			end

			it "should redirect to the stage" do
				expect(response).to redirect_to(@stage)
			end
		end

		context "stage not present" do		

			context "@backdrop.destroy" do
				before :each do
					user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
					cookies[:auth_token] = user.auth_token
					@backdrop = Backdrop.create(name: "bg1")
					delete :destroy, :params => { slug: @backdrop.slug, backdrop: @backdrop }
				end

				it "should destroy the backdrop" do
					expect(Backdrop.all).to_not include(@backdrop)
				end

				it "should flash success message" do
					expect(flash[:success]).to be_present
				end
				it "should redirect to backdrops path" do
					expect(response).to redirect_to(backdrops_path)
				end
			end

			context "@backdrop.destroy eq false" do
				before :each do
					user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
					cookies[:auth_token] = user.auth_token	

				end				

				it "should flash danger message" do
					backdrop = double
					allow(Backdrop).to receive(:find_by_slug!).and_return(backdrop)
					allow(backdrop).to receive(:slug).and_return("abc")
					allow(backdrop).to receive(:destroy).and_return(false)

					delete :destroy, :params => { slug: backdrop.slug, backdrop: backdrop }	
					
					expect(flash[:danger]).to be_present
				end

				it "should redirect to edit backdrop path" do
					backdrop = double
					allow(Backdrop).to receive(:find_by_slug!).and_return(backdrop)
					allow(backdrop).to receive(:slug).and_return("abc")
					allow(backdrop).to receive(:destroy).and_return(false)

					delete :destroy, :params => { slug: backdrop.slug, backdrop: backdrop }
					
					expect(response).to redirect_to(edit_backdrop_path(backdrop))
				end
			end
		end
	end
end
