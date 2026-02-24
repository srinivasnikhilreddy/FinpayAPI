module Platform
  class SessionsController < Devise::SessionsController
    # skip_before_action :authenticate_platform_user!, only: [:create]

    respond_to :json
    # before_action :ensure_rack_session

    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      respond_with(resource)
    end

    private

    def respond_with(resource, _opts = {})
      render json: {
        status: { code: 200, message: 'Platform login successful.' },
        data: {
          id: resource.id,
          email: resource.email,
          role: resource.role
        }
      }, status: :ok
    end

    def respond_to_on_destroy(_resource = nil)
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    end

    # def ensure_rack_session
    #   request.env['rack.session'] ||= {}
    # end
  end
end