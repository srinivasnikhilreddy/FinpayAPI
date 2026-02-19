module Api
  module V1
    class AccountsController < ApplicationController
      before_action :set_account, only: [:show, :update, :destroy]

      def index
        render json: Account.all
      end

      def show
        render json: @account
      end

      def create
        account = Account.new(account_params)
        if account.save
          render json: account, status: :created
        else
          render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @account.update(account_params)
          render json: @account
        else
          render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @account.destroy
        render json: { message: "Account deleted successfully" }
      end

      private

      def set_account
        @account = Account.find(params[:id])
      end

      def account_params
        params.require(:account).permit(:name, :balance)
      end
    end
  end
end
