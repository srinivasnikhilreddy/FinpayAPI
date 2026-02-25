module Api
  module V1
    class UsersController < ApplicationController
      before_action :require_admin!
      before_action :user, only: [:show, :update, :destroy]

      # GET /api/v1/users
      def index
        users = paginate(User.order(created_at: :desc))
        render json: {
          data: UserSerializer.new(users),
          meta: pagination_meta(users)
        }
      end

      # GET /api/v1/users/:id
      def show
        render json: UserSerializer.new(user)
      end

      # POST /api/v1/users
      def create
        user_ = User.new(user_params)

        if user_.save
          render json: UserSerializer.new(user_), status: :created
        else
          render json: {
            error: I18n.t("users.create_failed"),
            details: user_.errors.messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/users/:id
      def update
        # Prevent changing last admin to non-admin
        if user.admin? &&
           user_params[:role].present? &&
           user_params[:role] != "admin" &&
           User.where(role: "admin").count == 1
          return render json: {
            error: I18n.t("users.last_admin.create_failed")
          }, status: :unprocessable_entity
        end

        if user.update(user_params)
          render json: UserSerializer.new(user)
        else
          render json: {
            error: I18n.t("users.update_failed"),
            details: user.errors.messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        # Prevent deleting last admin
        if user.admin? && User.where(role: "admin").count == 1
          return render json: {
            error: I18n.t("users.last_admin.delete_failed")
          }, status: :unprocessable_entity
        end

        user.destroy!
        render json: { message: I18n.t("users.deleted") }, status: :ok
      end

      private

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
      end
    end
  end
end