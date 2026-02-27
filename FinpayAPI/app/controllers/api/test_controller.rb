class Api::TestController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { message: "You are authenticated" }
  end
end