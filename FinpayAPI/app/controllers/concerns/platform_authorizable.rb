module PlatformAuthorizable
  extend ActiveSupport::Concern

  def require_super_admin!
    render_forbidden unless current_platform_user&.super_admin?
  end

  def render_forbidden
    render json: { error: "Forbidden" }, status: :forbidden
  end
end