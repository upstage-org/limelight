require "rails_helper"

RSpec.describe MediaController do
  describe "GET index" do
    it "should return http success for users" do
      get :index
      # Login details
      expect(response).to have_http_status(:success)
    end

    it "should redirect guests" do
      get :index
      # Compare status code
      expect(response).to be_redirect
      # Compare specific page
      # expect(response).to redirect_to(assigns(:controller_method))
    end
  end
end
