require 'rails_helper'
require 'spec_helper'

describe backdrops_controller do

	fixtures :backdrops

	describe "#index" do
		
	end

	describe "#new" do
		
	end
	
	describe "#create" do

		backdrop = backdrops_controller.create()

		it "should redirect to edit backdrop path" do
			expect(response).to redirect_to(edit_backdrop_path)
			expect(flash[:success]).to match"#{@backdrop.name} created"			
		end

		it "backdrop not uploaded" do
			#expect(response).to 
			expect(flash[:danger]).to match"Something went wrong"
		end

	end

	describe "show" do
		it "" do
			
		end
	end

	describe "update" do
		
	end

	decribe "destroy" do
		
	end
	
	
end