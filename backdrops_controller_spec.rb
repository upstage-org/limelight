require 'rails_helper'

describe BackdropsController do

	before do
		
	end

	let(:backdrops) { Backdrop.all }

	describe "GET #index" do
		it "assigns all backdrops to @backdrops" do
			get :index
			expect(assigns(:backdrops)).to eq(@backdrops)
		end

		it "is a success" do
			expect(response).to have_http_status(:ok)
		end

		it "render 'index' template" do
			expect(response).to render_template("index")
		end
	end

	let(:newBackdrop) { Backdrop.new }

	describe "GET #new" do
		it "assigns a new backdrop to @backdrops" do
			get :new
			expect(assigns(:newBackdrop)).to eq(@backdrop)
		end

		it "is a success" do
			expect(response).to have_http_status(:ok)
		end

		it "render 'new backdrop'" do
			expect(response).to render_template("newBackdrop")
		end

	end

	let(:newlyCreatedBackdrop) { Backdrop.create }


	describe "GET #create" do

		it "flashes success message" do
			get :create
	 		expect(flash[:success]).to match"#{@backdrop.name} created"
	 	end
	
		it "should redirect to edit backdrop path" do
	 		expect(response).to redirect_to "/views/backdrops/edit.html"
	 	end
	#
	# 	it "backdrop not uploaded" do
	# 		#expect(response).to
	# 		expect(flash[:danger]).to match"Something went wrong"
	# 	end
	#
	# end
	#
	 describe "show" do
	 	it "shoud redirect to edit backdrop path" do
			expect(response).to redirect_to "/views/backdrops/edit.html.erb"
	 	end
	 end
	#
	# describe "update" do
	#
	# end
	#
	# decribe "destroy" do
	#
	#end
end
