module Api
  module V1
    class AccountsController < ApplicationController
      before_action :require_manager_or_admin!, only: [:index, :show]
      before_action :require_admin!, only: [:create, :update, :destroy]
      before_action :account, only: [:show, :update, :destroy]

      def index
        accounts = base_scope

        accounts = paginate(accounts)

        render json: {
          data: AccountListSerializer.new(accounts),
          meta: pagination_meta(accounts)
        }
      end

      def show
        render json: AccountSerializer.new(account)
      end

      def create
        account = Account.new(account_params)

        if account.save
          render json: AccountSerializer.new(account), status: :created
        else
          render json: {
            error: I18n.t("accounts.create_failed"),
            details: account.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if account.update(account_params)
          render json: AccountSerializer.new(account)
        else
          render json: {
            error: I18n.t("accounts.update_failed"),
            details: account.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        account.soft_delete!

        AuditLogger.log!(
          user: current_user,
          action: "account_soft_deleted",
          resource: account,
          request: request
        )

        render json: { message: I18n.t("accounts.deleted") }
      end

      private

      def base_scope
        @base_scope ||=
          if current_user.admin?
            Account.order(:name)
          else
            current_user.accounts.order(:name)
          end
      end

      def account
        @account ||=
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