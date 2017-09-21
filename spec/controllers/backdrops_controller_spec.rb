require 'rails_helper'

describe BackdropsController do

	let(:backdrops) { Backdrop.all }

	describe "GET #index" do
		it "assigns all backdrops to @backdrops" do
			get :index
			expect(assigns(:backdrops)).to eq(@backdrops)
		end

		it "is a sucess" do
			expect(response).to have_http_status(:ok)
		end

		it "render 'index' template" do
			user = User.create({ nickname: 'Admin', email: 'admin@local.instance', password: 'admin', password_confirmation: 'admin', is_active: true, email_confirmed: Time.zone.now })
			cookies[:auth_token] = user.auth_token
			get :index
			expect(response).to render_template('index')
		end
	end

	describe "#new" do

	end

	#
	# describe "#create" do
	#
	# 	backdrop = backdrops_controller.create()
	#
	# 	it "should redirect to edit backdrop path" do
	# 		expect(response).to redirect_to(edit_backdrop_path)
	# 		expect(flash[:success]).to match"#{@backdrop.name} created"
	# 	end
	#
	# 	it "backdrop not uploaded" do
	# 		#expect(response).to
	# 		expect(flash[:danger]).to match"Something went wrong"
	# 	end
	#
	# end
	#
	# describe "show" do
	# 	it "" do
	#
	# 	end
	# end
	#
	# describe "update" do
	#
	# end
	#
	# decribe "destroy" do
	#
	# end
end
