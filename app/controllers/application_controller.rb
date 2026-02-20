# ActionController::API is a lightweight version of ActionController::Base, which is used for building APIs.
# It does not include features that are typically used in full-stack applications, such as view rendering and session management. This makes it more efficient for handling API requests.
# ActionController::Base -> @Controller (spring boot)
# ActionController::API -> @RestController (spring boot)

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

end
