# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :authenticate_user!, only: [:create]

        respond_to :json

        # POST /api/v1/users
        def create
          # in routes => devise_for :user => devise internally sets: resource_class = User
          build_resource(sign_up_params) # => self.resource = User.new(sign_up_params)

          resource.role = "employee"

          if resource.save # => self.resource = User.create(sign_up_params)
            render json: {
              status: { code: 200, message: I18n.t("auth.signup.success") },
              data: UserSerializer.new(resource)
            }, status: :created
          else
            render json: {
              status: { code: 422, message: I18n.t("auth.signup.failure") },
              errors: resource.errors.messages
            }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
      end
    end
  end
end