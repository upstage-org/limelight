class UserRolesController < ApplicationController
  before_action :reject_anonymous
end
