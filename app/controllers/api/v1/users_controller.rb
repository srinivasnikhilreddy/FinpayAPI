module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      # GET api/v1/users
      def index
        render json: User.all
      end

      # GET api/v1/users/:id
      def show
        render json: @user
      end

      # POST api/v1/users
      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE api/v1/users/:id
      def destroy
        @user.destroy
        render json: { message: "User deleted successfully" }
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :role)
      end
    end
  end
end
