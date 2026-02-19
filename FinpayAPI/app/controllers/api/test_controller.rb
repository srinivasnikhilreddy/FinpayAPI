class Api::TestController < ApplicationController
  def index
    render json: { tenant: Apartment::Tenant.current }
  end
end
