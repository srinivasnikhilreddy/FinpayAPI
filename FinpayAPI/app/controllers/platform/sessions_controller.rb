module Platform
  class SessionsController < Devise::SessionsController
    # skip_before_action :authenticate_platform_user!, only: [:create]

    respond_to :json
    # before_action :ensure_rack_session

    # POST /login
    def create
      # Devise uses Warden, Warden runs database_authenticatable. It checks: email, encrypted_password (bcrypt compare), If valid -> authentication success
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource) # this triggers JWT dispatch
      respond_with(resource) 
    end

    private

    def respond_with(resource, _opts = {})
      render json: {
        status: { code: 200, message: I18n.t("platform.auth.login_success") },
        data: {
          id: resource.id,
          email: resource.email,
          role: resource.role
        }
      }, status: :ok
    end

    # DELETE /logout
    def respond_to_on_destroy(_resource = nil) # resource = nil
      render json: {
        status: { code: 200, message: I18n.t("platform.auth.logout_success") }
      }, status: :ok
    end

    # def ensure_rack_session
    #   request.env['rack.session'] ||= {}
    # end
  end
end