module Api
  module V1
    class UsersController < ApplicationController
      before_action :require_admin!
      before_action :set_user, only: [:show, :update, :destroy]

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
        render json: UserSerializer.new(@user)
      end

      # POST /api/v1/users
      def create
        user = User.new(user_params)

        if user.save
          render json: UserSerializer.new(user), status: :created
        else
          render json: {
            error: "User couldn't be created",
            details: user.errors.messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/users/:id
      def update
        # Prevent changing last admin to non-admin
        if @user.admin? &&
           user_params[:role].present? &&
           user_params[:role] != "admin" &&
           User.where(role: "admin").count == 1
          return render json: {
            error: "Cannot downgrade the last admin"
          }, status: :unprocessable_entity
        end

        if @user.update(user_params)
          render json: UserSerializer.new(@user)
        else
          render json: {
            error: "User couldn't be updated",
            details: @user.errors.messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        # Prevent deleting last admin
        if @user.admin? && User.where(role: "admin").count == 1
          return render json: {
            error: "Cannot delete the last admin"
          }, status: :unprocessable_entity
        end

        @user.destroy!
        render json: { message: "User deleted successfully" }, status: :ok
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
      end
    end
  end
end