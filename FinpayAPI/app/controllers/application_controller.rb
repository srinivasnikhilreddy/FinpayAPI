# ActionController::API is a lightweight version of ActionController::Base, which is used for building APIs.
# It does not include features that are typically used in full-stack applications, such as view rendering and session management. This makes it more efficient for handling API requests.
# ActionController::Base -> @Controller (spring boot)
# Api-Only => ActionController::API -> @RestController (spring boot)

class ApplicationController < ActionController::API
  include Authorizable
  include Authenticatable

  wrap_parameters format: [:json]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  rescue_from StandardError do |e|
    Rails.logger.error("[UNCAUGHT ERROR] #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))

    if Rails.env.test?
      raise e
    else
      render json: { error: I18n.t("common.internal_server_error") }, status: :internal_server_error
    end
  end
  
  protected

  # GET /api/v1/accounts/?page=1&per_page=10
  # Pagination: SELECT * FROM accounts ORDER BY created_at DESC LIMIT 25 OFFSET 0;
  def paginate(records)
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 10

    per_page = 10 if per_page <= 0
    per_page = 100 if per_page > 100
    
    records.page(page).per(per_page)
  end

  def pagination_meta(records)
    {
      current_page: records.current_page,
      next_page: records.next_page,
      prev_page: records.prev_page,
      total_pages: records.total_pages,
      total_count: records.total_count
    }
  end
end

=begin
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password])
  end
=end