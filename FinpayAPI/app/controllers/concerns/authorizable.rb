module Authorizable
  extend ActiveSupport::Concern

  def require_admin!
    render_forbidden("Admin access required") unless current_user&.admin?
  end

  def require_employee_or_admin!
    return if current_user&.employee? || current_user&.admin?
    render_forbidden("Employee access required")
  end

  def require_manager_or_admin!
    return if current_user&.manager? || current_user&.admin?
    render_forbidden("Manager access required")
  end

  def render_forbidden(message = "Forbidden")
    render json: { error: message }, status: :forbidden
  end
end