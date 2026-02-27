module Platform
  class BaseController < ActionController::API

    before_action :authenticate_platform_user!
    
    # include Devise::Controllers::Helpers
    # include Warden::Authentication::Helpers
    include PlatformAuthorizable

    wrap_parameters format: [:json]

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: "#{I18n.t("common.not_found")} #{e.message}" }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: e.message, details: e.record.errors }, status: :unprocessable_entity
    end

    rescue_from StandardError do |e|
      Rails.logger.error("Uncaught exception: #{e.class} - #{e.message}")
      render json: { error: I18n.t("common.internal_server_error") }, status: :internal_server_error
    end

    protected

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
end

=begin
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    end
=end