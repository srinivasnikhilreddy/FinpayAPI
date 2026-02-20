module Api
  module V1
    class UsersController < ApplicationController
      # Assuming authentication is handled by a before_action in ApplicationController
      # Before running show, update, or destroy, Rails will automatically run: set_user
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /api/v1/users
      def index
        render json: User.all
      end

      # GET /api/v1/users/:id
      def show
        render json: @user
      end
      
      # POST /api/v1/users
      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        render json: { message: "User deleted successfully" }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      # This method finds the user based on the ID provided in the params and assigns it to @user, which is then used in the show, update, and destroy actions.
      # GET /api/v1/users/5 => params[:id] will be 5, and User.find(5) will retrieve the user with ID 5 from the database.
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        # This method uses strong parameters to prevent mass assignment vulnerabilities. 
        # It requires that the params include a :user key and permits only the :name, :email, and :role attributes to be used for creating or updating a user.
        params.require(:user).permit(:name, :email, :role)
      end
    end
  end
end
