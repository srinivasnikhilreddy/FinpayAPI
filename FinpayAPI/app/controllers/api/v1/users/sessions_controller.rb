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
          # Devise uses Warden, Warden runs database_authenticatable. It checks: email, encrypted_password (bcrypt compare), If valid -> authentication success
          # Warden sets current_user = user i.e., env['warden'].set_user(user) => can access with request.env['warden']
          # Devise exposes current_user.
          self.resource = warden.authenticate!(auth_options)
          # def auth_options
          #   { scope: resource_name, recall: "#{controller_path}#new" }
          # end
          
          sign_in(resource_name, resource) # this triggers JWT dispatches -> devise-jwt middleware builds jwt payload (adds sub, exp, jti, claims), signs token with secret key and adds header
          # resource_name = :user ("user"/Symbol("user")), resource = user
          render json: {
            status: { code: 200, message: I18n.t("auth.login.success") },
            data: UserSerializer.new(resource)
          }, status: :ok
        end

        # when GET /api/v1/users with token 
        # Devise_JWT middleware runs before controller: Extract token, Verify signature, Verify expiration, Verify JTI matches DB
        # if valid -> devies sets: current_user = user -> then controller runs.
        private

        # DELETE /logout
        def respond_to_on_destroy(_resource = nil) # resource = nil
          render json: {
            status: { code: 200, message: I18n.t("auth.login.logout") }
          }, status: :ok
        end
        # Devise: Finds user, Changes user's jti, Old token's jti no longer matches DB, Old token becomes invalid
        # That is JWT revocation.

        # def ensure_rack_session
        #   request.env['rack.session'] ||= {}
        # end
      end
    end
  end
end