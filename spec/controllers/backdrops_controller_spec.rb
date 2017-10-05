require 'rails_helper'

describe BackdropsController do

	let(:backdrops) { Backdrop.all }
	let(:backdrop) { Backdrop.new }

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
		it "assigns backdrop to @backdrop" do
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
		before do
			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token			
		end

		context "when there is a valid backdrop" do
			subject { post :create, :params => { :backdrop => { name: "Pass Type", source_name: "bg1", source_content_type: "image/png" } } }

			it "redirects to edit backdrop path" do
				expect(subject).to redirect_to(edit_backdrop_path(Backdrop.last))
	 		end

	 		it "sets flash[:success]" do
	 			backdrop = subject
	 			expect(flash[:success]).to be_present
	 		end
	 	end

	 	context "when there is an invalid backdrop" do
	 		subject { post :create, :params => { :backdrop => { name: "" } } }

	 	 	it "renders 'new' template" do
	 	 		expect(subject).to render_template('new')
	 	 	end

	 	 	it "sets flash[:danger]" do
	 	 		backdrop = subject
	 	 		expect(flash[:danger]).to be_present
	 	 	end
	 	 end
	 end

	describe "#show" do
		subject { post :create, :params => { :backdrop => { name: "Pass Type", source_name: "bg1", source_content_type: "image/png" } } }

	 	it "redirect to edit backdrop path" do
	 		user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token
			expect(subject).to redirect_to(edit_backdrop_path(Backdrop.last))
	 	end
	end

	describe "#PATCH update" do
		before do
			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token			
		end

		context "when a stage is present" do
			before :each do
				@backdrop = Backdrop.create(name: "bg1")
				@stage = Stage.create(name: "testStage", owner_id: "1")
				@stage.backdrops << @backdrop
				patch :update, :params => { stage_slug: @stage.slug, stage: @stage, slug: @backdrop.slug, backdrop: { name: "New name" } }
				@backdrop.reload
			end

			it "add backdrop to the stage" do				
				expect(@stage.backdrops).to include(@backdrop)
			end

			it "flash success message" do
				expect(flash[:success]).to be_present
			end

			it "redirect to the stage" do
				expect(response).to redirect_to(@stage)
			end
		end

		context "when a stage is not present" do
			context "when @backdrop.update(backdrop_params) is true" do
				before do
					@backdrop = Backdrop.create(name: "bg1")
					patch :update, :params => { slug: @backdrop.slug, backdrop: { name: "New name" } }
					@backdrop.reload
				end

				it "flash success message" do
					expect(flash[:success]).to be_present
				end

				it "redirect to the edit backdrop path" do
					expect(response).to redirect_to(edit_backdrop_path(@backdrop))
				end

				it "change the name to the new name" do
					expect(@backdrop.name).to eq("New name")
				end
			end

			context "when @backdrop.update(backdrop_params) is false" do
				before do
					@backdrop = Backdrop.create(name: "bg1")
					patch :update, :params => { slug: @backdrop.slug, backdrop: { name: "" } }
					@backdrop.reload
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
			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token			
		end

		context "when a stage is present" do
			before do
				@backdrop = Backdrop.create(name: "bg1")
				@stage = Stage.create(name: "testStage", owner_id: "1")
				@stage.backdrops << @backdrop
				delete :destroy, :params => { stage_slug: @stage.slug, stage: @stage, slug: @backdrop.slug, backdrop: @backdrop }
				@stage.reload
			end

			it "delete backdrop from the stage" do
				expect(@stage.backdrops).to_not include(@backdrop)
			end

			it "flash success message" do
				expect(flash[:success]).to be_present
			end

			it "redirect to the stage" do
				expect(response).to redirect_to(@stage)
			end
		end

		context "when a stage not present" do		
			context "when @backdrop.destroy is true" do
				before do
					@backdrop = Backdrop.create(name: "bg1")
					delete :destroy, :params => { slug: @backdrop.slug, backdrop: @backdrop }
				end

				it "destroy the backdrop" do
					expect(Backdrop.all).to_not include(@backdrop)
				end

				it "flash success message" do
					expect(flash[:success]).to be_present
				end

				it "redirect to backdrops path" do
					expect(response).to redirect_to(media_path)
				end
			end

			context "when @backdrop.destroy is false" do		
				it "flash danger message" do
					backdrop = double
					allow(Backdrop).to receive(:find_by_slug!).and_return(backdrop)
					allow(backdrop).to receive(:slug).and_return("abc")
					allow(backdrop).to receive(:destroy).and_return(false)

					delete :destroy, :params => { slug: backdrop.slug, backdrop: backdrop }	
					
					expect(flash[:danger]).to be_present
				end

				it "redirect to edit backdrop path" do
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
