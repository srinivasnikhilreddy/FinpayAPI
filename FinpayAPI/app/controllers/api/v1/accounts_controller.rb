module Api
  module V1
    class AccountsController < ApplicationController
      before_action :require_manager_or_admin!, only: [:index, :show]
      before_action :require_admin!, only: [:create, :update, :destroy]
      before_action :set_account, only: [:show, :update, :destroy]

      def index
        accounts =
          if current_user.admin?
            Account.order(:name)
          else
            current_user.accounts.order(:name)
          end

        accounts = paginate(accounts)

        render json: {
          data: AccountSerializer.new(accounts),
          meta: pagination_meta(accounts)
        }
      end

      def show
        render json: AccountSerializer.new(@account)
      end

      def create
        @account = Account.new(account_params)

        if @account.save
          render json: AccountSerializer.new(@account), status: :created
        else
          render json: {
            error: "Account couldn't be created",
            details: @account.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @account.update(account_params)
          render json: AccountSerializer.new(@account)
        else
          render json: {
            error: "Account couldn't be updated",
            details: @account.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @account.soft_delete!

        AuditLogger.log!(
          user: current_user,
          action: "account_soft_deleted",
          resource: @account,
          request: request
        )

        render json: { message: "Account deleted successfully" }
      end

      private

      def set_account
        @account =
          if current_user.admin?
            Account.find(params[:id]) # admin can access all
          else
            current_user.accounts.find(params[:id]) # others only their own
          end
      end

      def account_params
        params.require(:account).permit(:name, :balance)
      end
    end
  end
end