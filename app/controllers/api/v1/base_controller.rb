class Api::V1::BaseController < ApplicationController
  doorkeeper_for  :all
  respond_to      :json


  private

  # Find the user that owns the access token
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end