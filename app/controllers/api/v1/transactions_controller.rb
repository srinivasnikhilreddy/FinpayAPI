module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_transaction, only: [:show, :destroy]

      def index
        render json: Transaction.all
      end

      def show
        render json: @transaction
      end

      def create
        transaction = Transaction.new(transaction_params)
        if transaction.save
          render json: transaction, status: :created
        else
          render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @transaction.destroy
        render json: { message: "Transaction deleted successfully" }
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
