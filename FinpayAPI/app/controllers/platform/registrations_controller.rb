module Platform
  class RegistrationsController < Devise::RegistrationsController
    # skip_before_action :authenticate_platform_user!, only: [:create]

    respond_to :json

    private

    def sign_up_params
      params.require(:platform_user).permit(:email, :password, :password_confirmation)
    end

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: { code: 200, message: 'Platform user registered successfully.' },
          data: {
            id: resource.id,
            email: resource.email,
            role: resource.role
          }
        }, status: :created
      else
        render json: {
          status: { code: 422, message: "User couldn't be created successfully." },
          errors: resource.errors.messages
        }, status: :unprocessable_entity
      end
    end
  end
end