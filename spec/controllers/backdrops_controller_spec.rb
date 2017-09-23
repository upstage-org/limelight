require 'rails_helper'

describe BackdropsController do

	#before(:each) do
		#user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', 
			#password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
		#cookies[:auth_token] = user.auth_token
	#end

	let(:backdrops) { Backdrop.all }
	let(:backdrop) { Backdrop.new }
	let(:test) { Backdrop.create(name: "test1", source: "test1") }
	let(:teststage) { Stage.new }

	describe "GET #index" do

		#before { user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
		#	cookies[:auth_token] = user.auth_token

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

			a = (Backdrop.create(name: "Pass Type", source_content_type: "image/png"))

			it "should redirect to edit backdrop path" do
				user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
				cookies[:auth_token] = user.auth_token
				#est2 :create, {backdrop: @test2, name: test2}
				expect(response).to redirect_to(edit_backdrop_path(a))
	 		end

	 		it "should set flash[:success]" do
	 			post :create
	 			expect(flash[:success]).to be_present
	 		end
	 	end

	 	context "Invalid backdrop" do

	 		b = Backdrop.create(name: "Fail Type", source_content_type: "audio/mp3")

	 		it "should render new template" do
	 			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
				cookies[:auth_token] = user.auth_token
				post :create	 			
	 			expect(response).to render_template("new")
	 		end

	 		it "should set flash[:danger]" do
	 			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
				cookies[:auth_token] = user.auth_token	 
	 			expect(flash.now[:danger]).to be_present
	 		end
	 	end
	 end
	
	describe "#show" do

		b = Backdrop.create(name: "Pass Type", source_content_type: "image/png")

	 	it "should redirect to edit backdrop path" do
	 		user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token
			#expect(response).to redirect_to '/backdrops_edit_url'
			expect(response).to redirect_to(edit_backdrop_path(b))
	 	end
	end
	
	describe "update" do
		context "stage is present" do

			#teststage = Stage.new({ owner: Admin })

			it "should add backdrop to the stage" do
				expect(assigns(:teststage)).to eq(@backdrop)
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
				it "should flash success message" do
					expect(flash[:success]).to be_present
				end
				it "should redirect to the edit backdrop path" do
					expect(response).to redirect_to(edit_backdrop_path)
				end
			end

			context "@backdrop.update(backdrop_params) eq false" do
				it "should flash danger message" do
					expect(flash.now[:danger]).to be_present
				end

				it "should render edit" do
					expect(response).to render_template("edit")
				end
			end
		end
	end
	
	describe "destroy" do
		context "stage is present" do

			it "should delete backdrop from the stage" do
				# destroy backdrop
				expect(response.status).to eq 200
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
				it "should flash success message" do
					expect(flash[:success]).to be_present
				end
				it "should redirect to backdrops path" do
					expect(response).to redirect_to(backdrop_path)
				end
			end

			context "@backdrop.destroy eq false" do
				it "should flash danger message" do
					expect(flash[:danger]).to be_present
				end

				it "should redirect to edit backdrop path" do
					expect(response).to redirect_to(edit_backdrop_path)
				end
			end
		end
	end	
end
