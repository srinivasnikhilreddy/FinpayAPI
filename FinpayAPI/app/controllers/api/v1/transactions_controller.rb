module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :require_manager_or_admin!, only: [:index, :show]
      before_action :require_admin!, only: [:create, :destroy]
      before_action :set_transaction, only: [:show, :destroy]

      def index
        transactions = paginate(Transaction.includes(:account).order(created_at: :desc))
        render json: {
          data: TransactionSerializer.new(transactions),
          meta: pagination_meta(transactions)
        }  
      end

      def show
        render json: TransactionSerializer.new(@transaction)
      end

      def create
        transaction = ::Transactions::ProcessTransaction.call!(
          params: transaction_params, 
          current_user: current_user, 
          request: request
        )
        
        render json: TransactionSerializer.new(transaction)
      end

      def destroy
        @transaction.soft_delete!

        AuditLogger.log!(
          user: current_user,
          action: "transaction_deleted",
          resource: @transaction,
          request: request
        )
        
        render json: { message: "Transaction deleted successfully" }, status: :ok
      end

      private

      def set_transaction
        @transaction = Transaction.find(params[:id])
      end

      def transaction_params
        params.require(:transaction).permit(:amount, :transaction_type, :account_id)
      end
    end
  end
end