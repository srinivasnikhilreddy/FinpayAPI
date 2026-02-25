# app/controllers/platform/registrations_controller.rb

module Platform
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :authenticate_platform_user!, only: [:create]
    respond_to :json

    # POST /platform/register
    def create
      # in routes => devise_for :user => devise internally sets: resource_class = User
      build_resource(sign_up_params) # => self.resource = PlatformUser.new(sign_up_params)

      resource.role = "super_admin"

      if resource.save # self.resource = PlatformUser.create(sign_up_params)
        render json: {
          status: { code: 201, message: I18n.t("platform.auth.register_success") },
          data: {
            id: resource.id,
            email: resource.email,
            role: resource.role
          }
        }, status: :created
      else
        render json: {
          errors: resource.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:platform_user)
            .permit(:email, :password, :password_confirmation)
    end
  end
end