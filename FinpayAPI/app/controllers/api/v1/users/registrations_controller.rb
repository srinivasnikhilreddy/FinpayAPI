# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :authenticate_user!, only: [:create]

        respond_to :json

        def create
          build_resource(sign_up_params)

          # Force role to employee (no self-promotion possible)
          resource.role = "employee"

          if resource.save
            render json: {
              status: { code: 200, message: 'Signed up successfully.' },
              data: UserSerializer.new(resource)
            }, status: :created
          else
            render json: {
              status: { code: 422, message: "User couldn't be created successfully." },
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