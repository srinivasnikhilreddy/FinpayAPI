# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        skip_before_action :authenticate_user!, only: [:create, :destroy]

        respond_to :json
        # before_action :ensure_rack_session

        # POST /login
        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)

          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: UserSerializer.new(resource)
          }, status: :ok
        end

        private

        # Required for Devise JSON API
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
  end
end